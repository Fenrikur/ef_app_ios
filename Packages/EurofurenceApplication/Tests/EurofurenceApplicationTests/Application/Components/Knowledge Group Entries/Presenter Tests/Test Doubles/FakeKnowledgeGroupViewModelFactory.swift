import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

struct FakeKnowledgeGroupViewModelFactory: KnowledgeGroupViewModelFactory {

    private let groupIdentifier: KnowledgeGroupIdentifier
    private let viewModel: KnowledgeGroupEntriesViewModel

    init(for groupIdentifier: KnowledgeGroupIdentifier, viewModel: KnowledgeGroupEntriesViewModel) {
        self.groupIdentifier = groupIdentifier
        self.viewModel = viewModel
    }

    func makeViewModelForGroup(
        identifier: KnowledgeGroupIdentifier, 
        completionHandler: @escaping (KnowledgeGroupEntriesViewModel) -> Void
    ) {
        guard identifier == groupIdentifier else { return }
        completionHandler(viewModel)
    }

}
