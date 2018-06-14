//
//  ScheduleViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ScheduleViewModel {

    func setDelegate(_ delegate: ScheduleViewModelDelegate)

}

protocol ScheduleViewModelDelegate {

    func scheduleViewModelDidUpdateDays(_ days: [ScheduleDayViewModel])
    func scheduleViewModelDidUpdateEvents(_ events: [ScheduleEventGroupViewModel])

}