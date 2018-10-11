//
//  ScheduleSearchViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

protocol ScheduleSearchViewModel {

    func setDelegate(_ delegate: ScheduleSearchViewModelDelegate)
    func updateSearchResults(input: String)
    func identifierForEvent(at indexPath: IndexPath) -> Event.Identifier?
    func filterToFavourites()
    func filterToAllEvents()
    func favouriteEvent(at indexPath: IndexPath)
    func unfavouriteEvent(at indexPath: IndexPath)

}

protocol ScheduleSearchViewModelDelegate {

    func scheduleSearchResultsUpdated(_ results: [ScheduleEventGroupViewModel])

}
