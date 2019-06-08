import EurofurenceModel

class EventFeedbackPresenter: EventFeedbackSceneDelegate, EventFeedbackDelegate {
    
    private let event: Event
    private let scene: EventFeedbackScene
    private let delegate: EventFeedbackModuleDelegate
    private let dayAndTimeFormatter: EventDayAndTimeFormatter
    private let successHaptic: SuccessHaptic
    private let failureHaptic: FailureHaptic
    private let successWaitingRule: EventFeedbackSuccessWaitingRule
    
    private let eventFeedback: EventFeedback
    
    init(event: Event,
         scene: EventFeedbackScene,
         delegate: EventFeedbackModuleDelegate,
         dayOfWeekFormatter: DayOfWeekFormatter,
         startTimeFormatter: HoursDateFormatter,
         endTimeFormatter: HoursDateFormatter,
         successHaptic: SuccessHaptic,
         failureHaptic: FailureHaptic,
         successWaitingRule: EventFeedbackSuccessWaitingRule) {
        self.event = event
        self.scene = scene
        self.delegate = delegate
        self.successHaptic = successHaptic
        self.failureHaptic = failureHaptic
        self.successWaitingRule = successWaitingRule
        
        dayAndTimeFormatter = EventDayAndTimeFormatter(dayOfWeekFormatter: dayOfWeekFormatter,
                                                       startTimeFormatter: startTimeFormatter,
                                                       endTimeFormatter: endTimeFormatter)
        
        eventFeedback = event.prepareFeedback()
        scene.setDelegate(self)
    }
    
    func eventFeedbackSceneDidLoad() {
        let viewModel = ViewModel(event: event,
                                  eventFeedback: eventFeedback,
                                  submitFeedback: { [unowned self] in self.submitFeedback() },
                                  cancelFeedback: { [unowned self] in self.cancelFeedback() },
                                  dayAndTimeFormatter: dayAndTimeFormatter)
        scene.bind(viewModel)
        scene.showFeedbackForm()
    }
    
    func eventFeedbackSubmissionDidFinish(_ feedback: EventFeedback) {
        scene.showFeedbackSubmissionSuccessful()
        successHaptic.play()
        successWaitingRule.evaluateRule(handler: delegate.eventFeedbackDismissed)
    }
    
    func eventFeedbackSubmissionDidFail(_ feedback: EventFeedback) {
        scene.showFeedbackForm()
        scene.showFeedbackSubmissionFailedPrompt()
        scene.enableNavigationControls()
        failureHaptic.play()
    }
    
    private func submitFeedback() {
        eventFeedback.submit(self)
        scene.showFeedbackSubmissionInProgress()
        scene.disableNavigationControls()
    }
    
    private func cancelFeedback() {
        delegate.eventFeedbackDismissed()
    }
    
    private struct EventDayAndTimeFormatter {
        
        var dayOfWeekFormatter: DayOfWeekFormatter
        var startTimeFormatter: HoursDateFormatter
        var endTimeFormatter: HoursDateFormatter
        
        func formatDayAndTime(from event: Event) -> String {
            let eventDayOfTheWeek = dayOfWeekFormatter.formatDayOfWeek(from: event.startDate)
            let eventStartTime = startTimeFormatter.hoursString(from: event.startDate)
            let eventEndTime = endTimeFormatter.hoursString(from: event.endDate)
            let eventDayAndTimeFormat = String.eventFeedbackDayAndTimeFormat
            
            return String.localizedStringWithFormat(eventDayAndTimeFormat,
                                                    eventDayOfTheWeek,
                                                    eventStartTime,
                                                    eventEndTime)
        }
        
    }
    
    private class ViewModel: EventFeedbackViewModel {
        
        private var eventFeedback: EventFeedback
        private let submit: () -> Void
        private let cancel: () -> Void
        
        var eventTitle: String
        var eventDayAndTime: String
        var eventLocation: String
        var eventHosts: String
        var defaultEventStarRating: Int = 0

        init(event: Event,
             eventFeedback: EventFeedback,
             submitFeedback: @escaping () -> Void,
             cancelFeedback: @escaping () -> Void,
             dayAndTimeFormatter: EventDayAndTimeFormatter) {
            let hosts: String = {
                let formatString = String.eventHostedByFormat
                return String.localizedStringWithFormat(formatString, event.hosts)
            }()
            
            self.eventFeedback = eventFeedback
            submit = submitFeedback
            cancel = cancelFeedback
            eventTitle = event.title
            eventDayAndTime = dayAndTimeFormatter.formatDayAndTime(from: event)
            eventLocation = event.room.name
            eventHosts = hosts
            defaultEventStarRating = eventFeedback.rating
        }
        
        func feedbackChanged(_ feedback: String) {
            eventFeedback.feedback = feedback
        }
        
        func ratingPercentageChanged(_ ratingPercentage: Float) {
            eventFeedback.rating = Int(ratingPercentage * 10) / 2
        }
        
        func submitFeedback() {
            submit()
        }
        
        func cancelFeedback() {
            cancel()
        }
        
    }
    
}
