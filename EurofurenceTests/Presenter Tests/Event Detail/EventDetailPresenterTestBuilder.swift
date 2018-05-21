//
//  EventDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit.UIViewController

class EventDetailPresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
    }
    
    private var interactor: EventDetailInteractor
    
    init() {
        interactor = DummyEventDetailInteractor()
    }
    
    @discardableResult
    func with(_ interactor: EventDetailInteractor) -> EventDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }
    
    func build(for event: Event2 = .random) -> Context {
        let sceneFactory = StubEventDetailSceneFactory()
        let module = EventDetailModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .build()
            .makeEventDetailModule(for: event)
        
        return Context(producedViewController: module, scene: sceneFactory.interface)
    }
    
}

extension EventDetailPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.simulateSceneDidLoad()
    }
    
}