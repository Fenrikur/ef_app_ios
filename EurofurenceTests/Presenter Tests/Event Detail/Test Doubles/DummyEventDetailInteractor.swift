//
//  DummyEventDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct DummyEventDetailInteractor: EventDetailInteractor {
    
    func makeViewModel(for event: Event2, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        
    }
    
}