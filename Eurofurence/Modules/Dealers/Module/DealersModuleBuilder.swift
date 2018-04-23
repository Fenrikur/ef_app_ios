//
//  DealersModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class DealersModuleBuilder {

    private var dealersSceneFactory: DealersSceneFactory

    init() {
        struct DummyDealersSceneFactory: DealersSceneFactory {
            func makeDealersScene() -> UIViewController & DealersScene {
                class DummyDealersScene: UIViewController, DealersScene {

                }

                return DummyDealersScene()
            }
        }

        dealersSceneFactory = DummyDealersSceneFactory()
    }

    @discardableResult
    func with(_ dealersSceneFactory: DealersSceneFactory) -> DealersModuleBuilder {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    func build() -> DealersModuleProviding {
        return DealersModule(dealersSceneFactory: dealersSceneFactory)
    }

}
