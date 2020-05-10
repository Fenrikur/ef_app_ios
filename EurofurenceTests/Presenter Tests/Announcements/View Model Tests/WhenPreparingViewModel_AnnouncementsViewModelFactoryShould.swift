@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModel_AnnouncementsViewModelFactoryShould: XCTestCase {

    var announcementsService: FakeAnnouncementsService!
    var interactor: DefaultAnnouncementsViewModelFactory!
    var announcementDateFormatter: FakeAnnouncementDateFormatter!
	var markdownRenderer: StubMarkdownRenderer!
    var announcements: [Announcement]!
    var announcement: (element: Announcement, index: Int)!

    override func setUp() {
        super.setUp()

        announcements = [StubAnnouncement].random
        announcement = announcements.randomElement()
        announcementsService = FakeAnnouncementsService(announcements: announcements)
        announcementDateFormatter = FakeAnnouncementDateFormatter()
		markdownRenderer = StubMarkdownRenderer()
		interactor = DefaultAnnouncementsViewModelFactory(
            announcementsService: announcementsService,
            announcementDateFormatter: announcementDateFormatter,
            markdownRenderer: markdownRenderer
        )
    }

    func testIndicateTheTotalNumberOfAnnouncements() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }

        XCTAssertEqual(announcements.count, viewModel?.numberOfAnnouncements)
    }

    func testAdaptAnnouncementTitles() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(announcement.element.title, announcementViewModel?.title)
    }

    func testAdaptAnnouncementContents() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

		XCTAssertEqual(markdownRenderer.stubbedContents(for: announcement.element.content), announcementViewModel?.detail)
    }

    func testAdaptAnnouncementDate() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)
        let expected = announcementDateFormatter.string(from: announcement.element.date)

        XCTAssertEqual(expected, announcementViewModel?.receivedDateTime)
    }

    func testAdaptReadAnnouncements() {
        var viewModel: AnnouncementsListViewModel?
        announcementsService.stubbedReadAnnouncements = [announcement.element.identifier]
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(true, announcementViewModel?.isRead)
    }

    func testAdaptUnreadAnnouncements() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(false, announcementViewModel?.isRead)
    }

    func testProvideTheExpectedIdentifier() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let actual = viewModel?.identifierForAnnouncement(at: announcement.index)

        XCTAssertEqual(announcement.element.identifier, actual)
    }

    func testUpdateTheAvailableViewModelsWhenAnnouncementsChange() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let newAnnouncements = [StubAnnouncement].random(upperLimit: announcements.count)
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateAnnouncements(newAnnouncements)
        let announcement = newAnnouncements.randomElement()
        let announcementViewModel = viewModel?.announcementViewModel(at: announcement.index)

        XCTAssertEqual(announcement.element.title, announcementViewModel?.title)
        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }

    func testUpdateTheAvailableViewModelsWhenReadAnnouncementsChange() {
        var viewModel: AnnouncementsListViewModel?
        interactor.makeViewModel { viewModel = $0 }
        let delegate = CapturingAnnouncementsListViewModelDelegate()
        viewModel?.setDelegate(delegate)
        announcementsService.updateReadAnnouncements(.random)

        XCTAssertTrue(delegate.toldAnnouncementsDidChange)
    }

}
