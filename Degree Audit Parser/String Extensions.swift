//
//  String Extensions.swift
//  Degree Audit Parser
//
//  Created by Dustin Knopoff on 11/30/20.
//

import Foundation

extension StringProtocol {
	func between<S: StringProtocol>(start: S, end: S, newOffset: Int? = nil) -> String {
		let startIndices = self.index(of: start)!
		let endIndices = self.index(of: end)!
		let substring = self[startIndices..<endIndices]
		let string = String(substring)
		let startIndex = string.startIndex
		guard let newOffset = newOffset else {
			return string
		}
		let newIndex = string.index(startIndex, offsetBy: newOffset)
		return String(string[newIndex...])
	}
	
	func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
		range(of: string, options: options)?.lowerBound
	}
	func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
		range(of: string, options: options)?.upperBound
	}
	func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
		ranges(of: string, options: options).map(\.lowerBound)
	}
	func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
		var result: [Range<Index>] = []
		var startIndex = self.startIndex
		while startIndex < endIndex,
			  let range = self[startIndex...]
				.range(of: string, options: options) {
			result.append(range)
			startIndex = range.lowerBound < range.upperBound ? range.upperBound :
				index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
		}
		return result
	}
	
	func matches(regex: String) -> [String] {
		do {
			let regex = try NSRegularExpression(pattern: regex)
			let results = regex.matches(in: String(self),
										range: NSRange(self.startIndex..., in: self))
			return results.map {
				String(self[Range($0.range, in: self)!])
			}
		} catch let error {
			print("invalid regex: \(error.localizedDescription)")
			return []
		}
	}

}
