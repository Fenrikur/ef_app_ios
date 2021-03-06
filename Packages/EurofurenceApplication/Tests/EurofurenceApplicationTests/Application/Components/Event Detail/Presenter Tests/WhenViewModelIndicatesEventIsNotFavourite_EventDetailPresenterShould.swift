import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIndicatesEventIsNotFavourite_EventDetailPresenterShould: XCTestCase {

    func testPlaySelectionChangedHaptic() {
        let event = FakeEvent.random
        let viewModel = CapturingEventDetailViewModel()
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateUnfavourited()

        XCTAssertTrue(context.hapticEngine.played)
    }

}
