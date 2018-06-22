//
//  ExtendedDealerData.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension ExtendedDealerData: RandomValueProviding {
    
    static var random: ExtendedDealerData {
        return ExtendedDealerData(artistImagePNGData: .random,
                                  preferredName: .random,
                                  alternateName: .random,
                                  categories: .random,
                                  dealerShortDescription: .random,
                                  websiteName: .random,
                                  twitterUsername: .random,
                                  telegramUsername: .random)
    }
    
}
