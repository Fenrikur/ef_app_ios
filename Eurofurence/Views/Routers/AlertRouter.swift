//
//  AlertRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol AlertRouter {

    func showAlert(title: String, message: String, actions: AlertAction ...)

}

struct AlertAction {

    var title: String

}
