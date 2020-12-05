//
//  Parser.swift
//  Degree Audit Parser
//
//  Created by Dustin Knopoff on 11/30/20.
//

import Foundation

class AuditToJson {
	var majors: [String]
	var minors: [String]
	
	var auditYear: Int
	var gradDate: Date
	
	var completeNUPaths: [NUPath]
	var completeCourses: [String]
	
	var ipNUPaths: [NUPath]
	var ipCourses: [String]
	
	var requiredNUPaths: [NUPath]
	var requiredCourses: [String]

	init(audit: String) {
		self.majors = []
		self.minors = []
		
		self.auditYear = 0
		self.gradDate = Date()
		
		self.completeNUPaths = []
		self.completeCourses = []
		
		self.ipNUPaths = []
		self.ipCourses = []
		
		self.requiredNUPaths = []
		self.requiredCourses = []
		
		let lines = audit.split(separator: "\n")
		for i in 0..<lines.count {
			if lines[i].contains("Course List") {
			} else if lines[i].contains("Major") {
				self.addMajor(String(lines[i]))
			} else if lines[i].contains("CATALOG YEAR") {
				self.add_year(String(lines[i]))
			} else if lines[i].contains("GRADUATION DATE:") {
				self.add_grad_date(line: String(lines[i]))
			} else if !lines[i].matches(regex: "(>OK |>IP |>NO )").isEmpty {
				self.get_nupaths(line: String(lines[i]))
			} else if !lines[i].matches(regex: "((FL|SP|S1|S2|SM)\\d\\d)").isEmpty {
				self.add_course_taken(line: String(lines[i]))
			}
		}
	}
	
	private func addMajor(_ line: String) {
		let major = line.between(start: "\">", end: "- Major", newOffset: 2)
		self.majors.append(major)
	}
	
	private func add_year(_ line: String) {
		let yearInd = line.endIndex(of: "CATALOG YEAR: ")!
		let yearEnd = line.index(yearInd, offsetBy: 4)
		let year = line[yearInd..<yearEnd]
		self.auditYear = Int(year.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
	}
	
	private func add_grad_date(line: String) {
		let dateInd = line.endIndex(of: "GRADUATION DATE: ")!
		let yearStart = line.index(dateInd, offsetBy: 6)
		let yearEnd = line.index(dateInd, offsetBy: 8)
		let monthEnd = line.index(dateInd, offsetBy: 2)
		let dayStart = line.index(dateInd, offsetBy: 3)
		let dayEnd = line.index(dateInd, offsetBy: 5)
		var components = DateComponents()
		let year = "20" + line[yearStart..<yearEnd]
		let month = Int(line[dateInd..<monthEnd])
		let day = Int(line[dayStart..<dayEnd])
		components.year = Int(year)!
		components.month = month!
		components.day = day!
		self.gradDate = Calendar.current.date(from: components)!
	}
	
	private func get_nupaths(line: String) {
		if !line.contains("(") {
			return
		}

		var nupathInd = line.index(of: "(")!
		nupathInd = line.index(nupathInd, offsetBy: 1)
		let nupathEnd = line.index(nupathInd, offsetBy: 2)
		guard let toAdd = NUPath(rawValue: String(line[nupathInd..<nupathEnd])) else {
			return
		}
		
		if line.contains(">OK ") {
			if !self.completeNUPaths.contains(toAdd) {
				self.completeNUPaths.append(toAdd);
			}
		} else if line.contains(">IP ") {
			if !self.ipNUPaths.contains(toAdd) {
				self.ipNUPaths.append(toAdd);
			}
		} else if line.contains(">NO ") {
			if !self.requiredNUPaths.contains(toAdd) {
				self.requiredNUPaths.append(toAdd);
			}
		}
	}
	
	private func or_search(line: String, needles: [String]) -> String.Index? {
		needles.filter {
			line.contains($0)
		}.map {
			line.index(of: $0)
		}[0]
	}
	
	private func add_course_taken(line: String) {
		var course = CompleteCourse()
		let startIdx = or_search(line: line, needles: ["FL", "SP", "S1", "S2", "SM"])!
		let courseString = line[startIdx...]
		
		if courseString.contains("NO AP") || courseString.contains("NO IB") {
			return
		}
		
		let idStart = courseString.index(courseString.startIndex, offsetBy: 9)
		let idEnd = courseString.index(courseString.startIndex, offsetBy: 13)
		let creditStart = courseString.index(courseString.startIndex, offsetBy: 18)
		let creditEnd = courseString.index(courseString.startIndex, offsetBy: 22)
		
		let classIdInt = Int(courseString[idStart..<idEnd])
		let creditHoursInt = Int(courseString[creditStart..<creditEnd])
		
		guard let classId = classIdInt, let creditHours = creditHoursInt else {
			return
		}
		
		course.classId = classId
		course.creditHours = creditHours
		course.hon = line.contains("(HON)")
		let subjectStart = courseString.index(courseString.startIndex, offsetBy: 4)
		let subjectEnd = courseString.index(courseString.startIndex, offsetBy: 9)
		course.subject = String(courseString[subjectStart..<subjectEnd]).trimmingCharacters(in: .whitespacesAndNewlines)
		let nameStart = courseString.index(courseString.startIndex, offsetBy: 30)
		let nameEnd = courseString.index(of: "</font>")!
		course.name = String(courseString[nameStart..<nameEnd])
			.trimmingCharacters(in: .whitespacesAndNewlines)
			.replacingOccurrences(of: "&amp;", with: "&")
			.replacingOccurrences(of: "(HON)", with: "")
			.replacingOccurrences(of: ";X", with: "")
		
		print(course)
	}
}

