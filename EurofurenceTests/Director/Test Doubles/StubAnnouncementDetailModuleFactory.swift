//
//  StubAnnouncementDetailModuleFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubAnnouncementDetailModuleFactory: AnnouncementDetailModuleProviding {
    
    let stubInterface = UIViewController()
    private(set) var capturedModel: Announcement2?
    func makeAnnouncementDetailModule(for announcement: Announcement2) -> UIViewController {
        capturedModel = announcement
        return stubInterface
    }
    
}