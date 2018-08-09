//
//  WhenPreparingViewModel_ForDealersDenEvent_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenPreparingViewModel_ForDealersDenEvent_EventDetailInteractorShould: XCTestCase {
    
    func testProduceDealersDenHeadingAfterDescriptionComponent() {
        var event = Event2.randomStandardEvent
        event.isDealersDen = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        let expected = EventDealersDenMessageViewModel(message: .dealersDen)
        
        XCTAssertEqual([expected], visitor.visitedViewModels)
    }
    
}