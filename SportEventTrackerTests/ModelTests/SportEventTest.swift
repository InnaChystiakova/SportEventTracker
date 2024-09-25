//
//  SportEventTest.swift
//  SportEventTrackerTests
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import XCTest
@testable import SportEventTracker

final class SportEventTest: XCTestCase {
    
    func testSportEventDecodingSuccess() throws {
        let sportData = try jsonData()
        let decoder = JSONDecoder()
        
        do {
            let sportEventList = try decoder.decode(SportEventList.self, from: sportData)
            let firstEvent = sportEventList.sportEvents[0]
            
            XCTAssertEqual(firstEvent.eventID, "45524202")
            XCTAssertEqual(firstEvent.sportID, "BASK")
            XCTAssertEqual(firstEvent.eventName, "Iraq-Palestine")
            XCTAssertEqual(firstEvent.eventStartTime, 1704069710)
        } catch {
            XCTFail("Decoding failed: \(error.localizedDescription)")
        }
    }
}
