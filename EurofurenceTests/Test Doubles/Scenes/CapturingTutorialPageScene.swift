//
//  CapturingTutorialPageScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation
import UIKit

class CapturingTutorialPageScene: TutorialPageScene {
    
    var tutorialPageSceneDelegate: TutorialPageSceneDelegate?

    private(set) var capturedPageTitle: String?
    func showPageTitle(_ title: String?) {
        capturedPageTitle = title
    }

    private(set) var capturedPageDescription: String?
    func showPageDescription(_ description: String?) {
        capturedPageDescription = description
    }

    private(set) var capturedPageImage: UIImage?
    func showPageImage(_ image: UIImage?) {
        capturedPageImage = image
    }
    
    private(set) var didShowPrimaryActionButton = false
    func showPrimaryActionButton() {
        didShowPrimaryActionButton = true
    }
    
    private(set) var capturedPrimaryActionDescription: String?
    func showPrimaryActionDescription(_ primaryActionDescription: String) {
        capturedPrimaryActionDescription = primaryActionDescription
    }
    
    private(set) var didShowSecondaryActionButton = false
    func showSecondaryActionButton() {
        didShowSecondaryActionButton = true
    }
    
    private(set) var capturedSecondaryActionDescription: String?
    func showSecondaryActionDescription(_ secondaryActionDescription: String) {
        capturedSecondaryActionDescription = secondaryActionDescription
    }
    
    func simulateTappingPrimaryActionButton() {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapPrimaryActionButton(self)
    }
    
    func simulateTappingSecondaryActionButton() {
        tutorialPageSceneDelegate?.tutorialPageSceneDidTapSecondaryActionButton(self)
    }

}
