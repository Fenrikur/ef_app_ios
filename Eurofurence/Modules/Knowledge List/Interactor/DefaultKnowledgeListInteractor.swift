//
//  DefaultKnowledgeListInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIImage

struct DefaultKnowledgeListInteractor: KnowledgeInteractor {

    var service: KnowledgeService

    func prepareViewModel(completionHandler: @escaping (KnowledgeListViewModel) -> Void) {
        service.fetchKnowledgeGroups { (groups) in
            let viewModel = KnowledgeListViewModel(knowledgeGroups: groups.map(self.knowledgeGroupViewModel))
            completionHandler(viewModel)
        }
    }

    private func knowledgeGroupViewModel(for group: KnowledgeGroup2) -> KnowledgeGroupViewModel {
        return KnowledgeGroupViewModel(title: group.title,
                                       icon: UIImage(),
                                       groupDescription: group.groupDescription,
                                       knowledgeEntries: group.entries.map(knowledgeEntryViewModel))
    }

    private func knowledgeEntryViewModel(for entry: KnowledgeEntry2) -> KnowledgeEntryViewModel {
        return KnowledgeEntryViewModel(title: entry.title)
    }

}
