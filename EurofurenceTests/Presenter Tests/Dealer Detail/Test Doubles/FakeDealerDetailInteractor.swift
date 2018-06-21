//
//  FakeDealerDetailInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeDealerDetailInteractor: DealerDetailInteractor {
    
    private let viewModel: FakeDealerDetailViewModel
    
    convenience init() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        self.init(viewModel: viewModel)
    }
    
    init(viewModel: FakeDealerDetailViewModel) {
        self.viewModel = viewModel
    }
    
    private(set) var capturedIdentifierForProducingViewModel: Dealer2.Identifier?
    func makeDealerDetailViewModel(for identifier: Dealer2.Identifier, completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        capturedIdentifierForProducingViewModel = identifier
        completionHandler(viewModel)
    }
    
}