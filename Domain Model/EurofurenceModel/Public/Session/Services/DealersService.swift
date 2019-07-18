import Foundation

public protocol DealersService {
    
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer?
    func makeDealersIndex() -> DealersIndex

}

public protocol DealersIndex {
    
    var availableCategories: DealerCategoriesCollection { get }

    func setDelegate(_ delegate: DealersIndexDelegate)
    func performSearch(term: String)

}

public protocol DealerCategoriesCollection {
    
    var numberOfCategories: Int { get }
    
    func category(at index: Int) -> DealerCategory
    func add(_ observer: DealerCategoriesCollectionObserver)
    
}

public protocol DealerCategoriesCollectionObserver {
    
    func categoriesCollectionDidChange(_ collection: DealerCategoriesCollection)
    
}

public protocol DealerCategory {
    
    var name: String { get }
    
    func activate()
    func deactivate()
    func add(_ observer: DealerCategoryObserver)
    
}

public protocol DealerCategoryObserver {
    
    func categoryDidActivate(_ category: DealerCategory)
    func categoryDidDeactivate(_ category: DealerCategory)
    
}

public protocol DealersIndexDelegate {

    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup])
    func indexDidProduceSearchResults(_ searchResults: [AlphabetisedDealersGroup])

}

public struct AlphabetisedDealersGroup {

    public var indexingString: String
    public var dealers: [Dealer]

    public init(indexingString: String, dealers: [Dealer]) {
        self.indexingString = indexingString
        self.dealers = dealers
    }

}
