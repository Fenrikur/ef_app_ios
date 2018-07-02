//
//  AnnouncementsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol AnnouncementsSceneFactory {

    func makeAnnouncementsScene() -> UIViewController & AnnouncementsScene

}