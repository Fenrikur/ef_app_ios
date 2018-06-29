//
//  NewsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol NewsInteractor {

    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate)
    func refresh()

}

protocol NewsInteractorDelegate {

    func viewModelDidUpdate(_ viewModel: NewsViewModel)
    func refreshDidBegin()
    func refreshDidFinish()

}
