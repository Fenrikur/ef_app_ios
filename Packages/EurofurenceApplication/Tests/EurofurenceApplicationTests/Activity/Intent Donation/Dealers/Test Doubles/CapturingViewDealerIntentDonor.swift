import EurofurenceApplication

class CapturingViewDealerIntentDonor: ViewDealerIntentDonor {
    
    private(set) var donatedDealerIntentDefinition: ViewDealerIntentDefinition?
    func donate(_ viewDealerIntent: ViewDealerIntentDefinition) {
        donatedDealerIntentDefinition = viewDealerIntent
    }
    
}
