import XCTest

import weatherTests

var tests = [XCTestCaseEntry]()
tests += weatherTests.allTests()
XCTMain(tests)
