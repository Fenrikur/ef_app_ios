//
//  DealersPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DealersPresenter: DealersSceneDelegate, DealersViewModelDelegate, DealersSearchViewModelDelegate {

    private struct AllDealersBinder: DealersBinder {

        var binder: DealerGroupsBinder

        func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
            binder.bind(component, toDealerGroupAt: index)
        }

        func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
            binder.bind(component, toDealerAt: indexPath)
        }

    }

    private struct SearchResultsBindingAdapter: DealersSearchResultsBinder {

        var binder: DealerGroupsBinder

        func bind(_ component: DealerGroupHeader, toDealerSearchResultGroupAt index: Int) {
            binder.bind(component, toDealerGroupAt: index)
        }

        func bind(_ component: DealerComponent, toDealerSearchResultAt indexPath: IndexPath) {
            binder.bind(component, toDealerAt: indexPath)
        }

    }

    private struct DealerGroupsBinder {

        var viewModels: [DealersGroupViewModel]

        func bind(_ component: DealerGroupHeader, toDealerGroupAt index: Int) {
            let group = viewModels[index]
            component.setDealersGroupTitle(group.title)
        }

        func bind(_ component: DealerComponent, toDealerAt indexPath: IndexPath) {
            let group = viewModels[indexPath.section]
            let dealer = group.dealers[indexPath.item]

            component.setDealerTitle(dealer.title)
            component.setDealerSubtitle(dealer.subtitle)
            dealer.fetchIconPNGData(completionHandler: component.setDealerIconPNGData)

            if dealer.isPresentForAllDays {
                component.hideNotPresentOnAllDaysWarning()
            } else {
                component.showNotPresentOnAllDaysWarning()
            }

            if dealer.isAfterDarkContentPresent {
                component.showAfterDarkContentWarning()
            } else {
                component.hideAfterDarkContentWarning()
            }
        }

    }

    private let scene: DealersScene
    private let interactor: DealersInteractor
    private var searchViewModel: DealersSearchViewModel?

    init(scene: DealersScene, interactor: DealersInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setDelegate(self)
        scene.setDealersTitle(.dealers)
    }

    func dealersSceneDidLoad() {
        interactor.makeDealersViewModel { (viewModel) in
            viewModel.setDelegate(self)
        }

        interactor.makeDealersSearchViewModel { (viewModel) in
            self.searchViewModel = viewModel
            viewModel.setSearchResultsDelegate(self)
        }
    }

    func dealersSceneDidChangeSearchQuery(to query: String) {
        searchViewModel?.updateSearchResults(with: query)
    }

    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        let itemsPerSection = groups.map({ $0.dealers.count })
        let binder = DealerGroupsBinder(viewModels: groups)
        scene.bind(numberOfDealersPerSection: itemsPerSection,
                   sectionIndexTitles: indexTitles,
                   using: AllDealersBinder(binder: binder))
    }

    func dealerSearchResultsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        let itemsPerSection = groups.map({ $0.dealers.count })
        let binder = DealerGroupsBinder(viewModels: groups)
        scene.bindSearchResults(numberOfDealersPerSection: itemsPerSection,
                                sectionIndexTitles: indexTitles,
                                using: SearchResultsBindingAdapter(binder: binder))
    }

}