//
//  ImageService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Alamofire
import Foundation
import ReactiveSwift
import Result
import UIKit

class ImageService: ImageServiceProtocol {
	private static let cacheDirectoryName = "Cache"
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.ImageService")
	private var disposables = CompositeDisposable()
	private let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	private let cacheDirectory: URL
	private let apiConnection: ApiConnectionProtocol

	required init(dataContext: DataContextProtocol, apiConnection: ApiConnectionProtocol) throws {
		cacheDirectory = baseDirectory.appendingPathComponent(ImageService.cacheDirectoryName, isDirectory: true)
		self.apiConnection = apiConnection

		if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
				try cacheDirectory.setExcludedFromBackup(true)
			} catch {
				throw ImageServiceError.FailedCreate(url: cacheDirectory, description: "Attempted to create and exclude cache directory from backup.")
			}
		}
	}
	
	func refreshCache(for images: [Image]) -> SignalProducer<Progress, ImageServiceError> {
		return SignalProducer { [unowned self] observer, disposable in
			var currentCache = try! FileManager.default.contentsOfDirectory(atPath: self.cacheDirectory.path)
			
			var producers: [SignalProducer<UIImage, ImageServiceError>] = []
			for image in images {
				producers.append(self.retrieve(for: image))
				if let index = currentCache.index(of: image.Id) {
					currentCache.remove(at: index)
				}
			}
			
			let progress = Progress(totalUnitCount: Int64(producers.count + 2))
			progress.completedUnitCount += 1
			observer.send(value: progress)
			
			print("Pruning \(currentCache.count) images from cache.")
			for imageId in currentCache {
				self.pruneCache(for: imageId)
			}
			print("Pruning done.")
			progress.completedUnitCount += 1
			observer.send(value: progress)
			
			let resultsProducer = SignalProducer<SignalProducer<UIImage, ImageServiceError>, NoError>(producers)
			disposable += resultsProducer.flatten(.merge).start({ event in
				switch event {
				case .value:
					progress.completedUnitCount += 1
					observer.send(value: progress)
					print("Image caching completed by \(progress.fractionCompleted)")
				case let .failed(error):
					print("Error while caching images from sync: \(error)")
					observer.send(error: error)
				case .completed:
					print("Finished caching images from sync")
					observer.sendCompleted()
				case .interrupted:
					print("Caching images from sync interrupted")
					observer.sendInterrupted()
				}
			})
		}
	}

	func retrieve(for image: Image) -> SignalProducer<UIImage, ImageServiceError> {
		return SignalProducer { [unowned self] observer, disposable in
			if self.validateCache(for: image) {
				do {
					let uiImage = try self.load(image)
					observer.send(value: uiImage)
					observer.sendCompleted()
				} catch let error as ImageServiceError {
					observer.send(error: error)
				} catch {}
			} else {
				disposable += self.apiConnection.downloadImage(for: image).observe(on: self.scheduler).startWithResult({ result in
					switch result {
					case let .success(value):
						do {
							try self.store(value, for: image)
							observer.send(value: value)
							observer.sendCompleted()
						} catch let error as ImageServiceError {
							observer.send(error: error)
						} catch {}
					case let .failure(error):
						observer.send(error: ImageServiceError.FailedDownload(image: image,
								description: error.localizedDescription))
					}
				})
			}
		}.start(on: scheduler)
	}

	func validateCache(for image: Image) -> Bool {
		do {
			let imageUrl = getUrl(for: image)
			let imageAttributes = try imageUrl.resourceValues(forKeys: [.isRegularFileKey, .isReadableKey, .fileSizeKey])

			guard let isRegularFile = imageAttributes.isRegularFile, isRegularFile else {
				return false
			}

			guard let isReadable = imageAttributes.isReadable, isReadable else {
				return false
			}

			guard let fileSize = imageAttributes.fileSize, fileSize != image.SizeInBytes else {
				pruneCache(for: image)
				return false
			}

			// TODO: Check if SHA1-hash matches

			return true
		} catch {
			return false
		}
	}
	
	func pruneCache(for image: Image) {
		do {
			try FileManager.default.removeItem(at: getUrl(for: image))
		} catch {
			/* */
		}
	}
	
	func pruneCache(for imageId: String) {
		do {
			try FileManager.default.removeItem(at: cacheDirectory.appendingPathComponent(imageId, isDirectory: false))
		} catch {
			/* */
		}
	}

	private func getUrl(for image: Image) -> URL {
		return cacheDirectory.appendingPathComponent(image.Id, isDirectory: false)
	}

	private func load(_ image: Image) throws -> UIImage {
		do {
			let imageUrl = getUrl(for: image)
			let imageData = try Data(contentsOf: imageUrl)
			guard let uiImage = UIImage(data: imageData) else {
				throw ImageServiceError.FailedRead(image: image, description: "Attempted to create UIImage from data retrieved from cache.")
			}
			return uiImage
		} catch let error as ImageServiceError {
			throw error
		} catch {
			throw ImageServiceError.FailedRead(image: image, description: nil)
		}
	}

	private func store(_ uiImage: UIImage, for image: Image) throws {
		do {
			guard let imageData = UIImagePNGRepresentation(uiImage) else {
				throw ImageServiceError.FailedConvert(image: image, description: "Attempted to convert UIImage to PNG representation.")
			}
			var imageUrl = getUrl(for: image)
			try imageData.write(to: imageUrl)
			try imageUrl.setExcludedFromBackup(true)
		} catch {
			throw ImageServiceError.FailedWrite(image: image, description: "Attempted to write image to cache and exclude it from backup.")
		}
	}
}
