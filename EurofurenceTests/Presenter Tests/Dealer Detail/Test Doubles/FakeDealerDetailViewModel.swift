//
//  FakeDealerDetailViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealerDetailViewModel: DealerDetailViewModel {
    
    init(numberOfComponents: Int) {
        self.numberOfComponents = numberOfComponents
    }
    
    var numberOfComponents: Int
    
    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) { }
    
    private(set) var toldToOpenWebsite = false
    func openWebsite() {
        toldToOpenWebsite = true
    }
    
    private(set) var toldToOpenTwitter = false
    func openTwitter() {
        toldToOpenTwitter = true
    }
    
}

class FakeDealerDetailSummaryViewModel: FakeDealerDetailViewModel {
    
    private let summary: DealerDetailSummaryViewModel
    
    init(summary: DealerDetailSummaryViewModel) {
        self.summary = summary
        super.init(numberOfComponents: 1)
    }
    
    override func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        visitor.visit(summary)
    }
    
}
