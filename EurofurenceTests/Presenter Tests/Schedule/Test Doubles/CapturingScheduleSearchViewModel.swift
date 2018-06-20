//
//  CapturingScheduleSearchViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingScheduleSearchViewModel: ScheduleSearchViewModel {
    
    fileprivate var delegate: ScheduleSearchViewModelDelegate?
    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedSearchInput: String?
    func updateSearchResults(input: String) {
        capturedSearchInput = input
    }
    
    fileprivate var stubbedIdentifiersByIndexPath = [IndexPath : Event2.Identifier]()
    func identifierForEvent(at indexPath: IndexPath) -> Event2.Identifier? {
        return stubbedIdentifiersByIndexPath[indexPath]
    }
    
}

extension CapturingScheduleSearchViewModel {
    
    func simulateSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel]) {
        delegate?.scheduleSearchResultsUpdated(results)
    }
    
    func stub(_ identifier: Event2.Identifier, at indexPath: IndexPath) {
        stubbedIdentifiersByIndexPath[indexPath] = identifier
    }
    
}