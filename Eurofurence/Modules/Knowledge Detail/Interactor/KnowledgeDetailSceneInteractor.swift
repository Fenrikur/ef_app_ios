//
//  KnowledgeDetailSceneInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol KnowledgeDetailSceneInteractor {

    func makeContents(for entry: KnowledgeEntry2) -> NSAttributedString

}