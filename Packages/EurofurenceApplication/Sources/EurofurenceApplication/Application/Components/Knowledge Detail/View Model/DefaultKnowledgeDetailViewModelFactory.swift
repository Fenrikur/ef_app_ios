import EurofurenceModel
import Foundation

public struct DefaultKnowledgeDetailViewModelFactory: KnowledgeDetailViewModelFactory {

    private struct ViewModel: KnowledgeEntryDetailViewModel {
        
        var title: String
        var contents: NSAttributedString
        var links: [LinkViewModel]
        var images: [KnowledgeEntryImageViewModel]
        
        private var linkModels: [Link]
        private let entry: KnowledgeEntry
        private let shareService: ShareService

        init(entry: KnowledgeEntry, contents: NSAttributedString, images: [Data], shareService: ShareService) {
            self.entry = entry
            self.title = entry.title
            self.contents = contents
            self.linkModels = entry.links
            self.shareService = shareService
            self.links = entry.links.map({ LinkViewModel(name: $0.name) })
            self.images = images.map(KnowledgeEntryImageViewModel.init)
        }

        func link(at index: Int) -> Link {
            return linkModels[index]
        }
        
        func shareKnowledgeEntry(_ sender: AnyObject) {
            shareService.share(KnowledgeEntryActivityItemSource(knowledgeEntry: entry), sender: sender)
        }

    }

    private let knowledgeService: KnowledgeService
    private let renderer: MarkdownRenderer
    private let shareService: ShareService
    
    public init(
        knowledgeService: KnowledgeService,
        renderer: MarkdownRenderer,
        shareService: ShareService
    ) {
        self.knowledgeService = knowledgeService
        self.renderer = renderer
        self.shareService = shareService
    }

    public func makeViewModel(
        for identifier: KnowledgeEntryIdentifier,
        completionHandler: @escaping (KnowledgeEntryDetailViewModel) -> Void
    ) {
        let service = knowledgeService
        service.fetchKnowledgeEntry(for: identifier) { (entry) in
            service.fetchImagesForKnowledgeEntry(identifier: identifier) { (images) in
                let renderedContents = self.renderer.render(entry.contents)
                let viewModel = ViewModel(
                    entry: entry,
                    contents: renderedContents,
                    images: images,
                    shareService: self.shareService
                )
                
                completionHandler(viewModel)
            }
        }
    }

}
