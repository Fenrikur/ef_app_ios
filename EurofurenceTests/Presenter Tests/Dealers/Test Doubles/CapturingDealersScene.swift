@testable import Eurofurence
import EurofurenceModel
import UIKit.UIViewController

class CapturingDealerCategoriesFilterScene: DealerCategoriesFilterScene {
    
    private(set) var boundNumberOfCategories: Int?
    func bind(_ numberOfCategories: Int) {
        boundNumberOfCategories = numberOfCategories
    }
    
}

class CapturingDealersScene: UIViewController, DealersScene {
    
    let filtersScene = CapturingDealerCategoriesFilterScene()

    private(set) var delegate: DealersSceneDelegate?
    func setDelegate(_ delegate: DealersSceneDelegate) {
        self.delegate = delegate
    }

    private(set) var capturedTitle: String?
    func setDealersTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var didShowRefreshIndicator = false
    func showRefreshIndicator() {
        didShowRefreshIndicator = true
    }

    private(set) var didHideRefreshIndicator = false
    func hideRefreshIndicator() {
        didHideRefreshIndicator = true
    }

    private(set) var capturedDealersPerSectionToBind = [Int]()
    private(set) var capturedSectionIndexTitles = [String]()
    private(set) var binder: DealersBinder?
    func bind(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersBinder) {
        capturedDealersPerSectionToBind = numberOfDealersPerSection
        capturedSectionIndexTitles = sectionIndexTitles
        self.binder = binder
    }

    private(set) var capturedDealersPerSectionToBindToSearchResults = [Int]()
    private(set) var capturedSectionIndexTitlesToBindToSearchResults = [String]()
    private(set) var searchResultsBinder: DealersSearchResultsBinder?
    func bindSearchResults(numberOfDealersPerSection: [Int], sectionIndexTitles: [String], using binder: DealersSearchResultsBinder) {
        capturedDealersPerSectionToBindToSearchResults = numberOfDealersPerSection
        capturedSectionIndexTitlesToBindToSearchResults = sectionIndexTitles
        searchResultsBinder = binder
    }

    private(set) var capturedIndexPathToDeselect: IndexPath?
    func deselectDealer(at indexPath: IndexPath) {
        capturedIndexPathToDeselect = indexPath
    }

}
