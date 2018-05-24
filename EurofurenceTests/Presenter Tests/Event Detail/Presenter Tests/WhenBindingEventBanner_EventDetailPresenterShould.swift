//
//  WhenBindingEventBanner_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubEventGraphicViewModel: EventDetailViewModel {
    
    private let graphic: EventGraphicViewModel
    private let expectedIndex: Int
    
    init(graphic: EventGraphicViewModel, at index: Int) {
        self.graphic = graphic
        expectedIndex = index
    }
    
    var numberOfComponents: Int = 1
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(graphic.randomized(ifFalse: index == expectedIndex))
    }
    
}

class WhenBindingEventBanner_EventDetailPresenterShould: XCTestCase {
    
    func testApplyTheBannerGraphicDataOntoTheScene() {
        let event = Event2.random
        let graphic = EventGraphicViewModel.random
        let index = Int.random
        let viewModel = StubEventGraphicViewModel(graphic: graphic, at: index)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        _ = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        
        XCTAssertEqual(graphic.pngGraphicData, context.scene.stubbedEventGraphicComponent.capturedPNGGraphicData)
    }
    
    func testReturnTheBoundGraphicComponent() {
        let event = Event2.random
        let graphic = EventGraphicViewModel.random
        let index = Int.random
        let viewModel = StubEventGraphicViewModel(graphic: graphic, at: index)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        
        XCTAssertTrue((boundComponent as? CapturingEventGraphicComponent) === context.scene.stubbedEventGraphicComponent)
    }
    
}