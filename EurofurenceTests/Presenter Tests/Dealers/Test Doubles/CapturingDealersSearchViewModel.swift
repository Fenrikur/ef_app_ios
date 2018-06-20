//
//  CapturingDealersSearchViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealersSearchViewModel: DealersSearchViewModel {
    
    var dealerGroups: [DealersGroupViewModel]
    var sectionIndexTitles: [String]
    
    init(dealerGroups: [DealersGroupViewModel] = .random, sectionIndexTitles: [String] = .random) {
        self.dealerGroups = dealerGroups
        self.sectionIndexTitles = sectionIndexTitles
    }
    
    func setSearchResultsDelegate(_ delegate: DealersSearchViewModelDelegate) {
        delegate.dealerSearchResultsDidChange(dealerGroups, indexTitles: sectionIndexTitles)
    }
    
    private(set) var capturedSearchQuery: String?
    func updateSearchResults(with query: String) {
        capturedSearchQuery = query
    }
    
}