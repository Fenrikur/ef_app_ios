import EurofurenceApplication
import EurofurenceModel

class CapturingKnowledgeGroupEntryScene: KnowledgeGroupEntryScene {

    private(set) var capturedTitle: String?
    func setKnowledgeEntryTitle(_ title: String) {
        capturedTitle = title
    }

}
