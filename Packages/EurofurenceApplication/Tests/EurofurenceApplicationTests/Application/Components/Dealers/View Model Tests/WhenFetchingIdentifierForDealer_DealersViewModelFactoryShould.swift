import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFetchingIdentifierForDealer_DealersViewModelFactoryShould: XCTestCase {

    func testProvideTheIdentifierForTheDealer() {
        let dealersService = FakeDealersService()
        let context = DealersViewModelTestBuilder().with(dealersService).build()
        var viewModel: DealersViewModel?
        context.viewModelFactory.makeDealersViewModel { viewModel = $0 }
        let modelDealers = dealersService.index.alphabetisedDealers
        let randomGroup = modelDealers.randomElement()
        let randomDealer = randomGroup.element.dealers.randomElement()
        let expected = randomDealer.element.identifier
        let indexPath = IndexPath(item: randomDealer.index, section: randomGroup.index)
        let actual = viewModel?.identifierForDealer(at: indexPath)

        XCTAssertEqual(expected, actual)
    }

}
