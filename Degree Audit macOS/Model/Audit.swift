//
//  Audit.swift
//  dk-degree audit
//
//  Created by Dustin Knopoff on 11/28/20.
//

import Foundation
import SwiftUI

class Audit: Codable, ObservableObject {
	var graduation: Date
	var gpa: Float
	var calendar_year: String
	var sections: [Section]
}

extension Audit {
	static func _default() -> Audit {
//		var graduation = DateComponents()
//		graduation.year = 2021
//		graduation.day = 07
//		graduation.month = 05
//
//		// Create date from components
//		let userCalendar = Calendar.current // user calendar
//		let someDateTime = userCalendar.date(from: graduation)!
//		let sections = Section._default()
//		return Audit(graduation: someDateTime, gpa: 3.6, calendar_year: "201810", sections: sections)
		let auditData = try! Data(contentsOf: Bundle.main.url(forResource: "default", withExtension: "json")!)
		let decoded = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		decoded.dateDecodingStrategy = .formatted(dateFormatter)
		return try! decoded.decode(Audit.self, from: auditData)
	}
	
	
}

extension Date {
	
	func years(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
	}
	
	func months(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
	}
	
	func days(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
	}
	
	func hours(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
	}
	
	func minutes(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
	}
	
	func seconds(sinceDate: Date) -> Int? {
		return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
	}
	
}

struct Section: Hashable, Codable {
	var name: String
	var status: Status
	var subsections: [Subsection]
	
	init(name: String, status: Status, subsections: [Subsection] = []) {
		self.name = name
		self.status = status
		self.subsections = subsections
	}
	
	enum Status: String,Codable {
		case not_started = "not_started"
		case in_progress = "in_progress"
		case complete = "complete"
		
		func toSystemName() -> some View {
			switch self {
			case .not_started:
				return Image(systemName: "exclamation.circle").foregroundColor(.red)
			case .complete:
				return Image(systemName: "checkmark.seal").foregroundColor(.green)
			case .in_progress:
				return Image(systemName: "circle.fill").foregroundColor(.yellow)
			}
		}
	}
	
}

extension Section {
	static func _default() -> [Section] {
		return [
			Section(name: "Computer Science Courses - Combined Major", status: .in_progress),
			Section(name: "Design Requirements", status: .in_progress),
			Section(name: "Degree Focused Electives", status: .in_progress),
			Section(name: "Integrative Requirement", status: .in_progress),
			Section(name: "Supporting courses: Computing & Social Issues", status: .complete),
			Section(name: "Computer Science Writing Requirement", status: .in_progress),
			Section(name: "Computer Science/Design Credit/GPA Requirements", status: .in_progress),
			Section(name: "Major GPA Requirement", status: .in_progress),
			Section(name: "Required General Electives", status: .complete),
		]
	}
}

struct Subsection: Hashable, Codable {
	var name: String
	var classes: [Class]
}

struct Class: Hashable, Codable {
	var term: String
	var college: String
	var class_no: Int
	var credits: Float
	var grade: Grade
	var name: String
	
	enum Grade: String, Codable {
		case A = "A"
		case A_minus = "A-"
		case B_plus = "B+"
		case B = "B"
		case B_minus = "B-"
		case C_plus = "C+"
		case C = "C"
		case C_minus = "C-"
		case D_plus = "D+"
		case D = "D"
		case D_minus = "D-"
		case F = "F"
		case T = "T"
		
		func asValue() -> Float {
			switch self {
			case .A:
				return 4.0
			case .A_minus:
				return 3.7
			case .B_plus:
				return 3.3
			case .B:
				return 3.0
			case .B_minus:
				return 2.7
			case .C_plus:
				return 2.3
			case .C:
				return 2.0
			case .C_minus:
				return 1.7
			case .D_plus:
				return 1.3
			case .D:
				return 1.0
			case .D_minus:
				return 0.7
			default:
				return 0.0
			}
		}
	}
}
