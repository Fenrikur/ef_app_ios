//
//  PhoneWindowWireframe.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController
import UIKit.UIWindow

struct PhoneWindowWireframe: WindowWireframe {

    static var shared: PhoneWindowWireframe = {
        let window = UIApplication.shared.delegate!.window!!
        return PhoneWindowWireframe(window: window)
    }()

    var window: UIWindow

    func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
    }

}