//
//  ScheduleScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleScene {

    func setDelegate(_ delegate: ScheduleSceneDelegate)
    func setScheduleTitle(_ title: String)
    func bind(numberOfDays: Int, using binder: ScheduleDaysBinder)
    func bind(numberOfItemsPerSection: [Int], using binder: ScheduleSceneBinder)
    func bindSearchResults(numberOfItemsPerSection: [Int], using binder: ScheduleSceneSearchResultsBinder)
    func selectDay(at index: Int)
    func deselectEvent(at indexPath: IndexPath)

}

protocol ScheduleSceneDelegate {

    func scheduleSceneDidLoad()
    func scheduleSceneDidSelectDay(at index: Int)
    func scheduleSceneDidSelectEvent(at indexPath: IndexPath)
    func scheduleSceneDidSelectSearchResult(at indexPath: IndexPath)
    func scheduleSceneDidUpdateSearchQuery(_ query: String)

}
