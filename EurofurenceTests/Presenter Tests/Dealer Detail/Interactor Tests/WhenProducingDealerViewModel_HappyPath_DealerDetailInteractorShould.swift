//
//  WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DealerDetailInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultDealerDetailInteractor
        var dealerData: ExtendedDealerData
        var dealerIdentifier: Dealer2.Identifier
    }
    
    func build(data: ExtendedDealerData = .random) -> Context {
        let identifier = Dealer2.Identifier.random
        let dealersService = FakeDealersService()
        dealersService.stub(data, for: identifier)
        let interactor = DefaultDealerDetailInteractor(dealersService: dealersService)
        
        return Context(interactor: interactor, dealerData: data, dealerIdentifier: identifier)
    }
    
}

extension DealerDetailInteractorTestBuilder.Context {
    
    func makeViewModel() -> DealerDetailViewModel? {
        var viewModel: DealerDetailViewModel?
        interactor.makeDealerDetailViewModel(for: dealerIdentifier) { viewModel = $0 }
        
        return viewModel
    }
    
}

class WhenProducingDealerViewModel_HappyPath_DealerDetailInteractorShould: XCTestCase {
    
    func testProduceExpectedNumberOfComponents() {
        let context = DealerDetailInteractorTestBuilder().build()
        let viewModel = context.makeViewModel()
        
        XCTAssertEqual(4, viewModel?.numberOfComponents)
    }
    
    func testProduceExpectedSummaryAtIndexZero() {
        let context = DealerDetailInteractorTestBuilder().build()
        let dealerData = context.dealerData
        let viewModel = context.makeViewModel()
        let expected = DealerDetailSummaryViewModel(artistImagePNGData: dealerData.artistImagePNGData,
                                                    title: dealerData.preferredName,
                                                    subtitle: dealerData.alternateName,
                                                    categories: dealerData.categories.joined(separator: ", "),
                                                    shortDescription: dealerData.dealerShortDescription,
                                                    website: dealerData.websiteName,
                                                    twitterHandle: dealerData.twitterUsername,
                                                    telegramHandle: dealerData.telegramUsername)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 0, to: visitor)
        
        XCTAssertEqual(expected, visitor.visitedSummary)
    }
    
    func testProduceExpectedLocationAndAvailability_WhenAlwaysAvailable_AndInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = true
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = true
        let context = DealerDetailInteractorTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: nil,
                                                                    limitedAvailabilityWarning: nil,
                                                                    locatedInAfterDarkDealersDenMessage: .locatedWithinAfterDarkDen)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)
        
        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }
    
    func testProduceExpectedLocationAndAvailability_WhenNotAvailableOnThursday_AndNotInAfterDarkDen_AtIndexOne() {
        var extendedDealerData = ExtendedDealerData.random
        extendedDealerData.isAttendingOnThursday = false
        extendedDealerData.isAttendingOnFriday = true
        extendedDealerData.isAttendingOnSaturday = true
        extendedDealerData.isAfterDark = false
        let context = DealerDetailInteractorTestBuilder().build(data: extendedDealerData)
        let viewModel = context.makeViewModel()
        
        let limitedAvailabilityWarning = String.formattedOnlyPresentOnDaysString(["Friday", "Saturday"])
        let expected = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                    mapPNGGraphicData: nil,
                                                                    limitedAvailabilityWarning: limitedAvailabilityWarning,
                                                                    locatedInAfterDarkDealersDenMessage: nil)
        let visitor = CapturingDealerDetailViewModelVisitor()
        viewModel?.describeComponent(at: 1, to: visitor)
        
        XCTAssertEqual(expected, visitor.visitedLocationAndAvailability)
    }
    
}
