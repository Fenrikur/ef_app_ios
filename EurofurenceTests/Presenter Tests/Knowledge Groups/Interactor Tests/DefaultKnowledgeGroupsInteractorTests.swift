//
//  DefaultKnowledgeGroupsInteractorTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class DefaultKnowledgeGroupsInteractorTests: XCTestCase {
    
    private func expectedViewModelForGroup(_ group: KnowledgeGroup2) -> KnowledgeListGroupViewModel {
        let entriesViewModels = group.entries.map(expectedViewModelForEntry)
        return KnowledgeListGroupViewModel(title: group.title,
                                       icon: UIImage(),
                                       groupDescription: group.groupDescription,
                                       knowledgeEntries: entriesViewModels)
    }
    
    private func expectedViewModelForEntry(_ entry: KnowledgeEntry2) -> KnowledgeListEntryViewModel {
        return KnowledgeListEntryViewModel(title: entry.title)
    }
    
    func testKnowledgeGroupsFromServiceAreTurnedIntoExpectedViewModels() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var actual: KnowledgeGroupsListViewModel?
        interactor.prepareViewModel { actual = $0 }
        
        let models: [KnowledgeGroup2] = .random
        let expected = KnowledgeGroupsListViewModel(knowledgeGroups: models.map(expectedViewModelForGroup))
        service.simulateFetchSucceeded(models)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testFetchingKnowledgeEntryReturnsExpectedEntryFromService() {
        let service = StubKnowledgeService()
        let interactor = DefaultKnowledgeGroupsInteractor(service: service)
        var actual: KnowledgeEntry2?
        let models: [KnowledgeGroup2] = .random
        let group = models.randomElement()
        let entry = group.element.entries.randomElement()
        let expected = entry.element
        interactor.fetchEntry(inGroup: group.index, index: entry.index) { actual = $0 }
        service.simulateFetchSucceeded(models)
        
        XCTAssertEqual(expected, actual)
    }
    
}