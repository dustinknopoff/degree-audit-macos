//
//  Degree_Audit_ParserTests.swift
//  Degree Audit ParserTests
//
//  Created by Dustin Knopoff on 11/30/20.
//

import XCTest
@testable import Degree_Audit_Parser

class Degree_Audit_ParserTests: XCTestCase {
	var testString: String = ""

    override func setUpWithError() throws {
		let testBundle = Bundle(for: type(of: self))
		let url = testBundle.url(forResource: "audit", withExtension: "html")
		testString = try! String(contentsOf: url!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		let parser = AuditToJson(audit: testString)
		XCTAssert(parser.auditYear == 2018)
		XCTAssert(parser.majors == ["Computer Science "])
		var comps = DateComponents()
		comps.year = 2021
		comps.month = 05
		comps.day = 20
		let expectedGradDate = Calendar.current.date(from: comps)!
		XCTAssert(parser.gradDate == expectedGradDate)
		XCTAssert(parser.ipNUPaths == [.WI, .WD, .CE])
		XCTAssert(parser.rewquiredNUPaths == [])
		XCTAssert(parser.completeNUPaths == [.ND, .EI, .IC, .FQ, .SI, .AD, .DD, .ER, .WF, .EX])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
