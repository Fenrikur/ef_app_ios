import EurofurenceApplication
import EurofurenceModel

class CapturingEventDetailComponentDelegate: EventDetailComponentDelegate {
    
    private(set) var eventToldToLeaveFeedbackFor: EventIdentifier?
    func eventDetailComponentDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
        eventToldToLeaveFeedbackFor = event
    }
    
}
