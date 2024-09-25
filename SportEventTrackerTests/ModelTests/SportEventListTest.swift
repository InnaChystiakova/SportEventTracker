//
//  SportEventListTest.swift
//  SportEventTrackerTests
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import XCTest
@testable import SportEventTracker

final class SportEventListTest: XCTestCase {
    
    func testSportEventListDecodingSuccess() throws {
        let sportData = try jsonData()
        let decoder = JSONDecoder()
        
        do {
            let sportEventList = try decoder.decode(SportEventList.self, from: sportData)
            
            XCTAssertNotNil(sportEventList, "Decoding successful")
            XCTAssertEqual(sportEventList.sportID, "BASK", "Sport ID should match")
            XCTAssertEqual(sportEventList.sportName, "BASKETBALL", "Sport name should match")
            XCTAssertEqual(sportEventList.sportEvents.count, 5, "Sport events count shpuld match")
        } catch {
            XCTFail("Decoding failed: \(error.localizedDescription)")
        }
    }
}
