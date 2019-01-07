//
//  DealerDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol DealerDetailInteractor {

    func makeDealerDetailViewModel(for identifier: DealerIdentifier, completionHandler: @escaping (DealerDetailViewModel) -> Void)

}
