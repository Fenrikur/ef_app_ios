import EventBus
import Foundation

class ConcreteSession: EurofurenceSession {

    private let eventBus = EventBus()

    private let sessionStateService: ConcreteSessionStateService
    private let refreshService: ConcreteRefreshService

    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationService: ConcreteAuthenticationService
    private let privateMessagesService: ConcretePrivateMessagesService
    private let conventionCountdownService: ConcreteConventionCountdownService

    private let announcementsService: ConcreteAnnouncementsService
    private let knowledgeService: ConcreteKnowledgeService
    private let eventsService: ConcreteEventsService
    private let dealersService: ConcreteDealersService
    private let significantTimeObserver: SignificantTimeObserver
    private let collectThemAllService: ConcreteCollectThemAllService
    private let mapsService: ConcreteMapsService
    private let notificationService: ConcreteNotificationService
    private let contentLinksService: ConcreteContentLinksService
    private let additionalServicesRepository: ConcreteAdditionalServicesRepository

    // swiftlint:disable function_body_length
    init(conventionIdentifier: ConventionIdentifier,
         api: API,
         userPreferences: UserPreferences,
         dataStoreFactory: DataStoreFactory,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
         clock: Clock,
         credentialStore: CredentialStore,
         conventionStartDateRepository: ConventionStartDateRepository,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         imageRepository: ImageRepository,
         significantTimeChangeAdapter: SignificantTimeChangeAdapter?,
         urlOpener: URLOpener?,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         longRunningTaskManager: LongRunningTaskManager?,
         mapCoordinateRender: MapCoordinateRender?,
         forceRefreshRequired: ForceRefreshRequired,
         companionAppURLRequestFactory: CompanionAppURLRequestFactory,
         refreshCollaboration: RefreshCollaboration,
         shareableURLFactory: ShareableURLFactory) {
        
        let dataStore = dataStoreFactory.makeDataStore(for: conventionIdentifier)

        sessionStateService = ConcreteSessionStateService(forceRefreshRequired: forceRefreshRequired,
                                                          userPreferences: userPreferences,
                                                          dataStore: dataStore)

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)

        privateMessagesService = ConcretePrivateMessagesService(eventBus: eventBus, api: api)
        
        additionalServicesRepository = ConcreteAdditionalServicesRepository(eventBus: eventBus,
                                                                            companionAppURLRequestFactory: companionAppURLRequestFactory)

        authenticationService = ConcreteAuthenticationService(eventBus: eventBus,
                                                              clock: clock,
                                                              credentialStore: credentialStore,
                                                              remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                              api: api)

        conventionCountdownService = ConcreteConventionCountdownService(eventBus: eventBus,
                                                                        conventionStartDateRepository: conventionStartDateRepository,
                                                                        clock: clock)

        announcementsService = ConcreteAnnouncementsService(eventBus: eventBus,
                                                            dataStore: dataStore,
                                                            imageRepository: imageRepository)

        knowledgeService = ConcreteKnowledgeService(eventBus: eventBus,
                                                    dataStore: dataStore,
                                                    imageRepository: imageRepository)

        let imageCache = ImagesCache(eventBus: eventBus,
                                     imageRepository: imageRepository)

        eventsService = ConcreteEventsService(eventBus: eventBus,
                                              dataStore: dataStore,
                                              imageCache: imageCache,
                                              clock: clock,
                                              timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                                              shareableURLFactory: shareableURLFactory)

        let imageDownloader = ImageDownloader(eventBus: eventBus,
                                              api: api,
                                              imageRepository: imageRepository)

        significantTimeObserver = SignificantTimeObserver(significantTimeChangeAdapter: significantTimeChangeAdapter,
                                                          eventBus: eventBus)
        dealersService = ConcreteDealersService(eventBus: eventBus,
                                                dataStore: dataStore,
                                                imageCache: imageCache,
                                                mapCoordinateRender: mapCoordinateRender,
                                                shareableURLFactory: shareableURLFactory)

        collectThemAllService = ConcreteCollectThemAllService(eventBus: eventBus,
                                                              collectThemAllRequestFactory: collectThemAllRequestFactory,
                                                              credentialStore: credentialStore)

        mapsService = ConcreteMapsService(eventBus: eventBus,
                                          dataStore: dataStore,
                                          imageRepository: imageRepository,
                                          dealers: dealersService)

        refreshService = ConcreteRefreshService(conventionIdentifier: conventionIdentifier,
                                                longRunningTaskManager: longRunningTaskManager,
                                                dataStore: dataStore,
                                                api: api,
                                                imageDownloader: imageDownloader,
                                                clock: clock,
                                                eventBus: eventBus,
                                                imageCache: imageCache,
                                                imageRepository: imageRepository,
                                                privateMessagesController: privateMessagesService,
                                                forceRefreshRequired: forceRefreshRequired,
                                                refreshCollaboration: refreshCollaboration)

        notificationService = ConcreteNotificationService(eventBus: eventBus,
                                                          eventsService: eventsService,
                                                          announcementsService: announcementsService,
                                                          refreshService: refreshService,
                                                          privateMessagesService: privateMessagesService)

        let urlEntityProcessor = URLEntityProcessor(eventsService: eventsService, dealersService: dealersService)
        contentLinksService = ConcreteContentLinksService(eventBus: eventBus, urlOpener: urlOpener, urlEntityProcessor: urlEntityProcessor)
        
        eventBus.subscribe(consumer: EventFeedbackService(api: api))

        privateMessagesService.refreshMessages()
    }

    lazy var services: Services = {
        return Services(notifications: notificationService,
                        refresh: refreshService,
                        announcements: announcementsService,
                        authentication: authenticationService,
                        events: eventsService,
                        dealers: dealersService,
                        knowledge: knowledgeService,
                        contentLinks: contentLinksService,
                        conventionCountdown: conventionCountdownService,
                        collectThemAll: collectThemAllService,
                        maps: mapsService,
                        sessionState: sessionStateService,
                        privateMessages: privateMessagesService)
    }()
    
    lazy var repositories: Repositories = Repositories(additionalServices: additionalServicesRepository)

}