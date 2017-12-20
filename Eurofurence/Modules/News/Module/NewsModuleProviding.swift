//
//  NewsModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol NewsModuleProviding {

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController

}

protocol NewsModuleDelegate {

    func newsModuleDidRequestLogin()
    func newsModuleDidRequestShowingPrivateMessages()

}