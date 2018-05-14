//
//  ConventionCountdownComponentViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension ConventionCountdownComponentViewModel: RandomValueProviding {
    
    static var random: ConventionCountdownComponentViewModel {
        return ConventionCountdownComponentViewModel(timeUntilConvention: .random)
    }
    
}