//
//  LoginViewControllerV2Factory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

struct LoginViewControllerV2Factory: LoginSceneFactory {

    private let storyboard = UIStoryboard(name: "Login", bundle: .main)

    func makeLoginScene() -> UIViewController & LoginScene {
        return storyboard.instantiate(LoginViewControllerV2.self)
    }

}