//
//  TestingApplicationContextBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class TestingApplicationContextBuilder {

    var firstTimeLaunchProviding: UserCompletedTutorialStateProviding
    var quoteGenerator: QuoteGenerator
    var presentationStrings: PresentationStrings
    var presentationAssets: PresentationAssets
    var networkReachability: NetworkReachability

    init() {
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        quoteGenerator = CapturingQuoteGenerator()
        presentationStrings = StubPresentationStrings()
        presentationAssets = StubPresentationAssets()
        networkReachability = StubNetworkReachability()
    }

    func forShowingTutorial() -> TestingApplicationContextBuilder {
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        return self
    }
    
    func withUserCompletedTutorialStateProviding(_ firstTimeLaunchProviding: UserCompletedTutorialStateProviding) -> TestingApplicationContextBuilder {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        return self
    }

    func withQuoteGenerator(_ quoteGenerator: QuoteGenerator) -> TestingApplicationContextBuilder {
        self.quoteGenerator = quoteGenerator
        return self
    }

    func withNetworkReachability(_ networkReachability: NetworkReachability) -> TestingApplicationContextBuilder {
        self.networkReachability = networkReachability
        return self
    }

    func build() -> ApplicationContext {
        return ApplicationContext(firstTimeLaunchProviding: firstTimeLaunchProviding,
                                  quoteGenerator: quoteGenerator,
                                  presentationStrings: presentationStrings,
                                  presentationAssets: presentationAssets,
                                  networkReachability: networkReachability)
    }

}
