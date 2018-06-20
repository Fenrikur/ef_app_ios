//
//  CapturingDealersViewModelDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealersViewModelDelegate: DealersViewModelDelegate {
    
    private(set) var capturedGroups = [DealersGroupViewModel]()
    private(set) var capturedIndexTitles = [String]()
    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel], indexTitles: [String]) {
        capturedGroups = groups
        capturedIndexTitles = indexTitles
    }
    
}

extension CapturingDealersViewModelDelegate {
    
    func capturedDealerViewModel(at indexPath: IndexPath) -> DealerViewModel? {
        guard capturedGroups.count > indexPath.section else { return nil }
        
        let group = capturedGroups[indexPath.section]
        guard group.dealers.count > indexPath.item else { return nil }
        
        return group.dealers[indexPath.item]
    }
    
}