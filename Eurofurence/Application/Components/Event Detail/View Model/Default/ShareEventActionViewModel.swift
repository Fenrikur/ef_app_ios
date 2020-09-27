import EurofurenceModel

public struct ShareEventActionViewModel: EventActionViewModel {
    
    let event: Event
    let shareService: ShareService
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.share)
    }
    
    public func perform(sender: Any?) {
        guard let sender = sender else { return }
        shareService.share(EventActivityItemSource(event: event), sender: sender)
    }
    
}