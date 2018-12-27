//
//  StubKnowledgeGroupsListViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import RandomDataGeneration

struct StubKnowledgeGroupsListViewModel: KnowledgeGroupsListViewModel {

    var knowledgeGroups: [KnowledgeListGroupViewModel] = []

    func setDelegate(_ delegate: KnowledgeGroupsListViewModelDelegate) {
        delegate.knowledgeGroupsViewModelsDidUpdate(to: knowledgeGroups)
    }

    func fetchIdentifierForGroup(at index: Int, completionHandler: @escaping (KnowledgeGroup.Identifier) -> Void) {
        completionHandler(stubbedGroupIdentifier(at: index))
    }

}

extension StubKnowledgeGroupsListViewModel: RandomValueProviding {

    static var random: StubKnowledgeGroupsListViewModel {
        return StubKnowledgeGroupsListViewModel(knowledgeGroups: .random)
    }

    func stubbedGroupIdentifier(at index: Int) -> KnowledgeGroup.Identifier {
        return KnowledgeGroup.Identifier("\(index)")
    }

}
