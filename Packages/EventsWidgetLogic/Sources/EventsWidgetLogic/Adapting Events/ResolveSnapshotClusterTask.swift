import Foundation.NSDate

struct ResolveSnapshotClusterTask {
    
    var repository: EventRepository
    var maximumEventsPerEntry: Int
    var snapshotDate: Date
    var completionHandler: (EventTimelineEntry) -> Void
    
    func beginClustering() {
        repository.loadEvents { (events) in
            let cluster = EventCluster.clusterEvents(events, startingAt: snapshotDate, maximumEventsPerCluster: maximumEventsPerEntry)
            let viewModels = cluster.events.map(EventViewModel.init(event:))
            let entry = EventTimelineEntry(date: cluster.clusterStartTime, events: viewModels, additionalEventsCount: cluster.additionalEventCount)
            completionHandler(entry)
        }
    }
    
}
