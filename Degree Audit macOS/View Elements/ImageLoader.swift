
//
//  URLImage.swift
//  LoadingImages
//
//  Created by Mohammad Azam on 6/20/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//
import Foundation
import SwiftUI
import Combine


final class ImageLoader: ObservableObject {
	enum ImageLoadingError: Error {
		case incorrectData
	}
	
	@Published private(set) var image: NSImage? = nil
	
	private let url: URL
	private var cancellable: AnyCancellable?
	
	init(url: URL) {
		self.url = url
	}
	
	deinit {
		cancellable?.cancel()
	}
	
	func load() {
		cancellable = URLSession
			.shared
			.dataTaskPublisher(for: url)
			.tryMap { data, _ in
				guard let image = NSImage(data: data) else {
					throw ImageLoadingError.incorrectData
				}
				
				return image
			}
			.receive(on: DispatchQueue.main)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { [weak self] image in
					self?.image = image
				}
			)
	}
	
	func cancel() {
		cancellable?.cancel()
	}
}
