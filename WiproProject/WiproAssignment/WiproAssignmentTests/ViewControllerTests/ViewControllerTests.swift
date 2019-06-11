//
//  ViewControllerTests.swift
//  WiproAssignmentTests
//
//  Created by Nallagangula Pavan Kumar on 11/06/19.
//  Copyright © 2019 Pavan Kumar. All rights reserved.
//

import XCTest
@testable import WiproAssignment

class ViewControllerTests: XCTestCase {

    var vc: ViewController!
    
    override func setUp() {

        vc = ViewController.instantiateFromStoryboard()
        vc.loadViewIfNeeded()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewDidLoad() {
        XCTAssertNotNil(vc.viewDidLoad())
    }
    
    func testSetUpCOllectionView() {
        XCTAssertNotNil(vc.setUpCOllectionView())
    }
    
    func testDidRecieveMemoryWarning() {
        XCTAssertNotNil(vc.didReceiveMemoryWarning())
    }
    
    func testRefresh() {
        XCTAssertNotNil(vc.refresh())
    }
    
    func testSetUpRefreshControl() {
        XCTAssertNotNil(vc.setUpRefreshControl())
    }
    
    func testShowLoadingIndicator() {
        XCTAssertNotNil(vc.showLoadingIndicator())
    }
    
    func testHideIndicatorView() {
        XCTAssertNotNil(vc.hideIndicatorView())
    }
    
    func testFetchAllRooms() {
        XCTAssertNotNil(vc.fetchAllRooms())
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
