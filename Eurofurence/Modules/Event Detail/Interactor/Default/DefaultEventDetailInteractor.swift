//
//  DefaultEventDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

private protocol EventDetailViewModelComponent {
    func describe(to visitor: EventDetailViewModelVisitor)
}

class DefaultEventDetailInteractor: EventDetailInteractor {

    private class ViewModel: EventDetailViewModel, EventsServiceObserver {

        struct SummaryComponent: EventDetailViewModelComponent {

            var viewModel: EventSummaryViewModel

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(viewModel)
            }

        }

        struct GraphicComponent: EventDetailViewModelComponent {

            var viewModel: EventGraphicViewModel

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(viewModel)
            }

        }

        struct DescriptionComponent: EventDetailViewModelComponent {

            var viewModel: EventDescriptionViewModel

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(viewModel)
            }

        }

        struct SponsorsOnlyComponent: EventDetailViewModelComponent {

            func describe(to visitor: EventDetailViewModelVisitor) {
                visitor.visit(EventSponsorsOnlyWarningViewModel(message: .thisEventIsForSponsorsOnly))
            }

        }

        private let components: [EventDetailViewModelComponent]
        private let event: Event2
        private let eventsService: EventsService
        private var isFavourite = false

        init(components: [EventDetailViewModelComponent],
             event: Event2,
             eventsService: EventsService) {
            self.components = components
            self.event = event
            self.eventsService = eventsService

            eventsService.add(self)
        }

        var numberOfComponents: Int {
            return components.count
        }

        private var delegate: EventDetailViewModelDelegate?
        func setDelegate(_ delegate: EventDetailViewModelDelegate) {
            self.delegate = delegate
            informDelegateAboutEventFavouriteState()
        }

        func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
            guard index < components.count else { return }
            components[index].describe(to: visitor)
        }

        func favourite() {
            eventsService.favouriteEvent(identifier: event.identifier)
        }

        func unfavourite() {
            eventsService.unfavouriteEvent(identifier: event.identifier)
        }

        func eventsDidChange(to events: [Event2]) { }
        func runningEventsDidChange(to events: [Event2]) { }
        func upcomingEventsDidChange(to events: [Event2]) { }

        func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
            isFavourite = identifiers.contains(event.identifier)
            informDelegateAboutEventFavouriteState()
        }

        private func informDelegateAboutEventFavouriteState() {
            if isFavourite {
                delegate?.eventFavourited()
            } else {
                delegate?.eventUnfavourited()
            }
        }

    }

    private let dateRangeFormatter: DateRangeFormatter
    private let eventsService: EventsService
	private let markdownRenderer: MarkdownRenderer

    convenience init() {
        self.init(dateRangeFormatter: FoundationDateRangeFormatter.shared,
                  eventsService: EurofurenceApplication.shared,
				  markdownRenderer: DefaultDownMarkdownRenderer())
    }

	init(dateRangeFormatter: DateRangeFormatter, eventsService: EventsService, markdownRenderer: MarkdownRenderer) {
        self.dateRangeFormatter = dateRangeFormatter
        self.eventsService = eventsService
		self.markdownRenderer = markdownRenderer
    }

    func makeViewModel(for identifier: Event2.Identifier, completionHandler: @escaping (EventDetailViewModel) -> Void) {
        eventsService.fetchEvent(for: identifier) { (event) in
            guard let event = event else { return }
            var components = [EventDetailViewModelComponent]()

            if let graphicData = event.posterGraphicPNGData ?? event.bannerGraphicPNGData {
                let graphicViewModel = EventGraphicViewModel(pngGraphicData: graphicData)
                components.append(ViewModel.GraphicComponent(viewModel: graphicViewModel))
            }

			let abstract = self.markdownRenderer.render(event.abstract)
            let startEndTimeString = self.dateRangeFormatter.string(from: event.startDate, to: event.endDate)
            let summaryViewModel = EventSummaryViewModel(title: event.title,
                                                         subtitle: abstract,
                                                         eventStartEndTime: startEndTimeString,
                                                         location: event.room.name,
                                                         trackName: event.track.name,
                                                         eventHosts: event.hosts)
            components.append(ViewModel.SummaryComponent(viewModel: summaryViewModel))

            if event.isSponsorOnly {
                components.append(ViewModel.SponsorsOnlyComponent())
            }

            if !event.eventDescription.isEmpty, event.eventDescription != event.abstract {
				let description = self.markdownRenderer.render(event.eventDescription)
                let descriptionViewModel = EventDescriptionViewModel(contents: description)
                components.append(ViewModel.DescriptionComponent(viewModel: descriptionViewModel))
            }

            let viewModel = ViewModel(components: components, event: event, eventsService: self.eventsService)
            completionHandler(viewModel)
        }
    }

}
