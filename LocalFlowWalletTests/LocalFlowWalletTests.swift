//
//  LocalFlowWalletTests.swift
//  LocalFlowWalletTests
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import XCTest
@testable import LocalFlowWallet

class LocalFlowWalletTests: XCTestCase {
    
    //Double Extension
    
    func testExtentionDouble() {
        
        let double = 42.982648;
        
        let roundedFirst = double.roundToDecimal(2)
        let roundedSecond = double.roundToDecimal(3)
        let roundedThird = double.roundToDecimal(5)
        let roundedFourth = double.roundToDecimal(1)
        
        XCTAssertEqual(roundedFirst, 42.98, "Fail to round with 2 decimals")
        XCTAssertEqual(roundedSecond, 42.983, "Fail to round with 3 decimals")
        XCTAssertEqual(roundedThird, 42.98265, "Fail to round with 5 decimals")
        XCTAssertEqual(roundedFourth, 43.0, "Fail to round with 1 decimal")
    }
    
    func testRoundedString() {
        
        let doubleNumber = 43.987654
        let string = doubleNumber.roundedString()
        XCTAssertEqual(string, "43.99", "Falied to round double to string")
    }
    
    func testRoundedAsIntString() {
        
        let doubleNumber = 43.524
        let otherDoubleNumber = 42.493
        let firstString = doubleNumber.roundedAsIntString()
        let secondString = otherDoubleNumber.roundedAsIntString()
        XCTAssertEqual(firstString, "44", "Failed to round to int")
        XCTAssertEqual(secondString, "42", "Failed to round to int by defect")
    }
    
    //String extension
    
    func testStringToInt() {
        
        let stringInt = "32"
        let stringDouble = "65.6542"
        let stringNil = "ciao"
        
        let integer = stringInt.integerValue
        let double = stringDouble.integerValue
        let nilValue = stringNil.integerValue
        
        XCTAssertEqual(integer, 32, "")
        XCTAssertEqual(double, 66, "")
        XCTAssertNil(nilValue)
    }
    
    func testStringToDouble() {
        
        let stringInt = "32"
        let stringDouble = "65.6542"
        let stringNil = "ciao"
        
        let integer = stringInt.doubleValue
        let double = stringDouble.doubleValue
        let nilValue = stringNil.doubleValue
        
        XCTAssertEqual(integer, 32.0, "")
        XCTAssertEqual(double, 65.6542, "")
        XCTAssertNil(nilValue)
    }
    
    //Date extension
    
    func testDateToString() {

        // 11/02/09 at 11.31PM
        
        let date = NSDate(timeIntervalSince1970: 1234567890)
        
        let dateString = date.dateString()
        
        XCTAssertEqual(dateString, "13 February 2009 at 23:31:30 GMT", "")
    }
    
}
