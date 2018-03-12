//
//  CapturingKnowledgeDetailScene.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class CapturingKnowledgeDetailScene: UIViewController, KnowledgeDetailScene {
    
    fileprivate var delegate: KnowledgeDetailSceneDelegate?
    func setKnowledgeDetailSceneDelegate(_ delegate: KnowledgeDetailSceneDelegate) {
        self.delegate = delegate
    }
    
    private(set) var capturedTitle: String?
    func setKnowledgeDetailTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var capturedKnowledgeAttributedText: NSAttributedString?
    func setAttributedKnowledgeEntryContents(_ contents: NSAttributedString) {
        capturedKnowledgeAttributedText = contents
    }
    
}

extension CapturingKnowledgeDetailScene {
    
    func simulateSceneDidLoad() {
        delegate?.knowledgeDetailSceneDidLoad()
    }
    
}