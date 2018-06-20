//
//  DefaultDealersInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct DefaultDealersInteractor: DealersInteractor, DealersIndexDelegate {

    private let dealersService: DealersService
    private let defaultIconData: Data
    private let viewModel: ViewModel
    private let searchViewModel: SearchViewModel
    private let eventBus = EventBus()

    init() {
        self.init(dealersService: EurofurenceApplication.shared)
    }

    init(dealersService: DealersService) {
        let defaultIcon = #imageLiteral(resourceName: "defaultAvatar")
        let defaultIconData = UIImagePNGRepresentation(defaultIcon)!
        self.init(dealersService: dealersService, defaultIconData: defaultIconData)
    }

    init(dealersService: DealersService, defaultIconData: Data) {
        self.dealersService = dealersService
        self.defaultIconData = defaultIconData

        let index = dealersService.makeDealersIndex()
        viewModel = ViewModel(eventBus: eventBus)
        searchViewModel = SearchViewModel(eventBus: eventBus, index: index)

        index.setDelegate(self)
    }

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {
        completionHandler(viewModel)
    }

    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void) {
        completionHandler(searchViewModel)
    }

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: alphabetisedGroups)
        eventBus.post(AllDealersChangedEvent(alphabetisedGroups: groups, indexTitles: indexTitles))
    }

    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup]) {
        let (groups, indexTitles) = makeViewModels(from: searchResults)
        eventBus.post(SearchResultsDidChangeEvent(alphabetisedGroups: groups, indexTitles: indexTitles))
    }

    private func makeViewModels(from alphabetisedGroups: [AlphabetisedDealersGroup]) -> (groups: [DealersGroupViewModel], titles: [String]) {
        let groups = alphabetisedGroups.map { (alphabetisedGroup) -> DealersGroupViewModel in
            return DealersGroupViewModel(title: alphabetisedGroup.indexingString,
                                         dealers: alphabetisedGroup.dealers.map(makeDealerViewModel))
        }

        let indexTitles = alphabetisedGroups.map({ $0.indexingString })

        return (groups: groups, titles: indexTitles)
    }

    private func makeDealerViewModel(for dealer: Dealer2) -> DealerVM {
        return DealerVM(dealer: dealer, dealersService: dealersService, defaultIconData: defaultIconData)
    }

    private class AllDealersChangedEvent {

        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(alphabetisedGroups: [DealersGroupViewModel], indexTitles: [String]) {
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private struct SearchResultsDidChangeEvent {

        private(set) var alphabetisedGroups: [DealersGroupViewModel]
        private(set) var indexTitles: [String]

        init(alphabetisedGroups: [DealersGroupViewModel], indexTitles: [String]) {
            self.alphabetisedGroups = alphabetisedGroups
            self.indexTitles = indexTitles
        }

    }

    private class ViewModel: DealersViewModel, EventConsumer {

        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(eventBus: EventBus) {
            eventBus.subscribe(consumer: self)
        }

        private var delegate: DealersViewModelDelegate?
        func setDelegate(_ delegate: DealersViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

        func consume(event: AllDealersChangedEvent) {
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerGroupsDidChange(groups, indexTitles: indexTitles)
        }

    }

    private class SearchViewModel: DealersSearchViewModel, EventConsumer {

        private let index: DealersIndex
        private var groups = [DealersGroupViewModel]()
        private var indexTitles = [String]()

        init(eventBus: EventBus, index: DealersIndex) {
            self.index = index
            eventBus.subscribe(consumer: self)
        }

        private var delegate: DealersSearchViewModelDelegate?
        func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate) {
            self.delegate = delegate
            delegate.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

        func updateSearchResults(with query: String) {
            index.performSearch(term: query)
        }

        func consume(event: SearchResultsDidChangeEvent) {
            groups = event.alphabetisedGroups
            indexTitles = event.indexTitles

            delegate?.dealerSearchResultsDidChange(groups, indexTitles: indexTitles)
        }

    }

    private struct DealerVM: DealerViewModel {

        private let dealer: Dealer2
        private let dealersService: DealersService
        private let defaultIconData: Data

        init(dealer: Dealer2, dealersService: DealersService, defaultIconData: Data) {
            self.dealer = dealer
            self.dealersService = dealersService
            self.defaultIconData = defaultIconData

            title = dealer.preferredName
            subtitle = dealer.alternateName
            isPresentForAllDays = dealer.isAttendingOnThursday && dealer.isAttendingOnFriday && dealer.isAttendingOnSaturday
            isAfterDarkContentPresent = dealer.isAfterDark
        }

        var title: String
        var subtitle: String?
        var isPresentForAllDays: Bool = true
        var isAfterDarkContentPresent: Bool = false

        func fetchIconPNGData(completionHandler: @escaping (Data) -> Void) {
            dealersService.fetchIconPNGData(for: dealer.identifier) { (iconPNGData) in
                completionHandler(iconPNGData ?? self.defaultIconData)
            }
        }

    }

}