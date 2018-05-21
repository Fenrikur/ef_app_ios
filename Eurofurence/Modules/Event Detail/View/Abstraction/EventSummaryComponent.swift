//
//  EventSummaryComponent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol EventSummaryComponent {

    func setEventTitle(_ title: String)
    func setEventSubtitle(_ subtitle: String)
    func setEventStartEndTime(_ startEndTime: String)
    func setEventLocation(_ location: String)
    func setTrackName(_ trackName: String)
    func setEventHosts(_ eventHosts: String)

}