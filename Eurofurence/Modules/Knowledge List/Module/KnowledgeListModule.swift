//
//  KnowledgeListModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct KnowledgeListModule: KnowledgeListModuleProviding {

    var knowledgeSceneFactory: KnowledgeListSceneFactory
    var knowledgeListInteractor: KnowledgeInteractor

    func makeKnowledgeListModule(_ delegate: KnowledgeListModuleDelegate) -> UIViewController {
        let scene = knowledgeSceneFactory.makeKnowledgeListScene()
        let presenter = KnowledgeListPresenter(scene: scene,
                                               knowledgeListInteractor: knowledgeListInteractor,
                                               delegate: delegate)
        scene.setDelegate(presenter)

        return scene
    }

}