//
//  AnnouncementDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class AnnouncementDetailPresenterTestBuilder {
    
    struct Context {
        var announcementDetailScene: UIViewController
        var sceneFactory: StubAnnouncementDetailSceneFactory
        var scene: CapturingAnnouncementDetailScene
        var announcementViewModel: AnnouncementViewModel
    }
    
    func build() -> Context {
        let sceneFactory = StubAnnouncementDetailSceneFactory()
        let announcement: Announcement2 = .random
        let announcementDetailInteractor = StubAnnouncementDetailInteractor()
        let module = AnnouncementDetailModuleBuilder()
            .with(sceneFactory)
            .with(StubAnnouncementDetailInteractorFactory(interactor: announcementDetailInteractor, for: announcement))
            .build()
            .makeAnnouncementDetailModule(for: announcement)
        
        return Context(announcementDetailScene: module,
                       sceneFactory: sceneFactory,
                       scene: sceneFactory.stubbedScene,
                       announcementViewModel: announcementDetailInteractor.viewModel)
    }
    
}

extension AnnouncementDetailPresenterTestBuilder.Context {
    
    func simulateAnnouncementDetailSceneDidLoad() {
        scene.delegate?.announcementDetailSceneDidLoad()
    }
    
}