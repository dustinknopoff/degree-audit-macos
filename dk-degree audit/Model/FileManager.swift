//
//  FileManager.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/29/20.
//

import Foundation


class FilesManager {
	enum Error: Swift.Error {
		case fileAlreadyExists
		case invalidDirectory
		case writtingFailed
		case readingFailed
		case fileNotExists
	}
	let fileManager: FileManager
	init(fileManager: FileManager = .default) {
		self.fileManager = fileManager
	}
	func save(fileNamed: String, data: Data) throws {
		guard let url = makeURL(forFileNamed: fileNamed) else {
			throw Error.invalidDirectory
		}
		if fileManager.fileExists(atPath: url.absoluteString) {
			throw Error.fileAlreadyExists
		}
		do {
			try data.write(to: url)
		} catch {
			debugPrint(error)
			throw Error.writtingFailed
		}
	}
	private func makeURL(forFileNamed fileName: String) -> URL? {
		guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
			return nil
		}
		return url.appendingPathComponent(fileName)
	}
	
	func read(fileNamed: String) throws -> Data {
		guard let url = makeURL(forFileNamed: fileNamed) else {
			throw Error.invalidDirectory
		}
		guard fileManager.fileExists(atPath: url.absoluteString) else {
			throw Error.fileNotExists
		}
		do {
			return try Data(contentsOf: url)
		} catch {
			debugPrint(error)
			throw Error.readingFailed
		}
	}
}
