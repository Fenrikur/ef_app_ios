@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_ForDealersDenEvent_EventDetailInteractorShould: XCTestCase {

    func testProduceDealersDenHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isDealersDen = true
        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
        let expected = EventDealersDenMessageViewModel(message: .dealersDen)

        XCTAssertEqual(expected, visitor.visited(ofKind: EventDealersDenMessageViewModel.self))
    }

}
