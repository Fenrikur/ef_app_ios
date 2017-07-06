//
//  ContextManager.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ContextManager {
	private static let scheduler = QueueScheduler(qos: .userInitiated, name: "org.eurofurence.app.ContextManagerScheduler")
	private var apiConnection: ApiConnectionProtocol
	private var dataContext: DataContextProtocol
	private var dataStore: DataStoreProtocol
	private var imageService: ImageServiceProtocol

	private(set) lazy var syncWithApi: Action<Date?, Progress, NSError>? =
			Action { sinceDate in
				return SignalProducer<Progress, NSError> { [unowned self] observer, disposable in					
					let progress = Progress(totalUnitCount: 3)
					let parameters: ApiConnectionProtocol.Parameters?
					if let sinceDate = sinceDate {
						let since = Iso8601DateFormatter.instance.string(from: sinceDate)
						parameters = ["since": since]
					} else {
						parameters = nil
					}

					disposable += self.apiConnection.doGet("Sync", parameters: parameters).observe(on: ContextManager.scheduler).startWithResult({ (apiResult: Result<Sync, ApiConnectionError>) -> Void in

						progress.completedUnitCount += 1
						observer.send(value: progress)

						if let sync = apiResult.value {
							disposable += self.dataContext.applySync.apply(sync).startWithCompleted {
								progress.completedUnitCount += 1
								observer.send(value: progress)
								UserSettings.LastSyncDate.setValue(sync.CurrentDateTimeUtc)

								disposable += self.imageService.refreshCache(for: self.dataContext.Images.value).startWithCompleted {
									progress.completedUnitCount += 1
									observer.send(value: progress)
									observer.sendCompleted()
								}
							}
						} else {
							// TODO: Rollback to last persisted state in order to maintain consistency
							observer.send(error: apiResult.error as NSError? ??
								ApiConnectionError.UnknownError(functionName: #function,
								                                description: "Unexpected empty value on sync result") as NSError)
						}
					})
				}.observe(on: ContextManager.scheduler)
			}

	init(apiConnection: ApiConnectionProtocol, dataContext: DataContextProtocol,
	     dataStore: DataStoreProtocol, imageService: ImageServiceProtocol) {
		self.apiConnection = apiConnection
		self.dataContext = dataContext
		self.dataStore = dataStore
		self.imageService = imageService
	}

	func clearAll() {
		dataStore.clearAll().startWithCompleted {
			self.dataContext.clearAll()
		}
	}
}
