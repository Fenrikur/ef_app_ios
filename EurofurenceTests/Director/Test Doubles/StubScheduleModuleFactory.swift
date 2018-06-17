//
//  StubScheduleModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubScheduleModuleFactory: ScheduleModuleProviding {

    let stubInterface = UIViewController()
    fileprivate var delegate: ScheduleModuleDelegate?
    func makeScheduleModule(_ delegate: ScheduleModuleDelegate) -> UIViewController {
        self.delegate = delegate
        return stubInterface
    }
    
}

extension StubScheduleModuleFactory {
    
    func simulateDidSelectEvent(_ identifier: Event2.Identifier) {
        delegate?.scheduleModuleDidSelectEvent(identifier: identifier)
    }
    
}