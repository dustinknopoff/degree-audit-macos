//
//  Types.swift
//  Degree Audit Parser
//
//  Created by Dustin Knopoff on 11/30/20.
//

import Foundation

enum NUPath: String, Codable {
	case ND = "ND"
	case EI = "EI"
	case IC = "IC"
	case FQ = "FQ"
	case SI = "SI"
	case AD = "AD"
	case DD = "DD"
	case ER = "ER"
	case WF = "WF"
	case WD = "WD"
	case WI = "WI"
	case EX = "EX"
	case CE = "CE"
}

struct CompleteCourse: Codable {
	var hon: Bool
	var subject: String
	var classId: Int
	var name: String
	var creditHours: Int
	var season: Season
	var year: Int
	var termId: Int
	
	init() {
		self.hon = false
		self.subject = ""
		self.classId = 0
		self.name = ""
		self.creditHours = 0
		self.season = .FL
		self.year = 0
		self.termId = 0
	}
}

enum Season: String, Codable {
	case FL = "FL"
	case SP = "SP"
	case S1 = "S1"
	case S2 = "S2"
	case SM = "SM"
}
