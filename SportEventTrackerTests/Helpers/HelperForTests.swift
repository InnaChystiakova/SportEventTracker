//
//  HelperForTests.swift
//  SportEventTrackerTests
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import XCTest

extension XCTestCase {
    func jsonData() throws -> Data {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: "TestSportEvents", withExtension: "json") else {
            throw NSError(domain: "MissingFile", code: 404, userInfo: [NSLocalizedDescriptionKey: "Missing file: TestSportEvents.json"])
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            throw NSError(domain: "FileReadError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to read JSON from file: \(error.localizedDescription)"])
        }
    }
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated. Potential memopry leak.", file: file, line: line)
        }
    }
}
