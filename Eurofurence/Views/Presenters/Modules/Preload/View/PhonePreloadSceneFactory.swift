//
//  PhonePreloadSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

struct PhonePreloadSceneFactory: PreloadSceneFactory {

    private let storyboard = UIStoryboard(name: "Preload", bundle: .main)

    func makePreloadScene() -> UIViewController & SplashScene {
        return storyboard.instantiateViewController(withIdentifier: "PreloadViewController") as! PreloadViewController
    }

}
