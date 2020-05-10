import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class DealerDetailViewModelFactoryTestBuilder {

    struct Context {
        var interactor: DefaultDealerDetailViewModelFactory
        var dealersService: FakeDealersService
        var dealerData: ExtendedDealerData
        var dealerIdentifier: DealerIdentifier
        var dealer: FakeDealer
        var shareService: CapturingShareService
    }

    func build(data: ExtendedDealerData = .random) -> Context {
        let dealersService = FakeDealersService()
        let dealer = FakeDealer.random
        dealer.extendedData = data
        dealersService.add(dealer)
        
        let shareService = CapturingShareService()
        let interactor = DefaultDealerDetailViewModelFactory(dealersService: dealersService, shareService: shareService)

        return Context(interactor: interactor,
                       dealersService: dealersService,
                       dealerData: data,
                       dealerIdentifier: dealer.identifier,
                       dealer: dealer,
                       shareService: shareService)
    }

}

extension DealerDetailViewModelFactoryTestBuilder.Context {

    func makeViewModel() -> DealerDetailViewModel? {
        var viewModel: DealerDetailViewModel?
        interactor.makeDealerDetailViewModel(for: dealerIdentifier) { viewModel = $0 }

        return viewModel
    }

}
