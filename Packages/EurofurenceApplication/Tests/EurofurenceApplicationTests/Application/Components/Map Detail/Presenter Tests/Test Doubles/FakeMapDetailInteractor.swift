import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeMapDetailViewModelFactory: MapDetailViewModelFactory {

    private let expectedMapIdentifier: MapIdentifier

    init(expectedMapIdentifier: MapIdentifier = .random) {
        self.expectedMapIdentifier = expectedMapIdentifier
    }

    let viewModel = FakeMapDetailViewModel()
    func makeViewModelForMap(identifier: MapIdentifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard identifier == expectedMapIdentifier else { return }
        completionHandler(viewModel)
    }

}

class FakeMapDetailViewModel: MapDetailViewModel {

    var mapImagePNGData: Data = .random
    var mapName: String = .random

    private(set) var positionToldToShowMapContentsFor: (x: Float, y: Float)?
    fileprivate var contentsVisitor: MapContentVisitor?
    func showContentsAtPosition(x: Float, y: Float, describingTo visitor: MapContentVisitor) {
        positionToldToShowMapContentsFor = (x: x, y: y)
        contentsVisitor = visitor
    }

}

extension FakeMapDetailViewModel {

    func resolvePositionalContent(with position: MapCoordinate) {
        contentsVisitor?.visit(position)
    }

    func resolvePositionalContent(with content: MapInformationContextualContent) {
        contentsVisitor?.visit(content)
    }

    func resolvePositionalContent(with dealer: DealerIdentifier) {
        contentsVisitor?.visit(dealer)
    }

    func resolvePositionalContent(with mapContents: MapContentOptionsViewModel) {
        contentsVisitor?.visit(mapContents)
    }

}
