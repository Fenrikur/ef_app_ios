import EurofurenceApplication
import EurofurenceIntentDefinitions
import EurofurenceModel
import Intents

struct ConcreteEventIntentDonor: EventIntentDonor {
    
    func donateEventIntent(definition: ViewEventIntentDefinition) {
        guard #available(iOS 12.0, *) else { return }
        
        let intent = ViewEventIntent(intentDefinition: definition)
        let interation = INInteraction(intent: intent, response: nil)
        interation.identifier = definition.identifier.rawValue
        
        interation.donate { (error) in
            if let error = error {
                print("Error donating interaction: \(error)")
            }
        }
    }
    
}
