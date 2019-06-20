@testable import Eurofurence
import EurofurenceModel
import UIKit

class CollectThemAllPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingHybridWebScene
        var service: FakeCollectThemAllService
    }

    func build() -> Context {
        let sceneFactory = StubHybridWebSceneFactory()
        let service = FakeCollectThemAllService()
        let module = CollectThemAllModuleBuilder(service: service)
            .with(sceneFactory)
            .build()
            .makeCollectThemAllModule()

        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       service: service)
    }

}

extension CollectThemAllPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.delegate?.hybridWebSceneDidLoad()
    }

}
