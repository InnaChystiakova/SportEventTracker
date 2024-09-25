//
//  SportEvent.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import Foundation

struct SportEvent: Decodable {
    let eventUUID: String
    let eventID: String?
    let sportID: String?
    let eventName: String?
    let eventStartTime: TimeInterval?
    
    private enum CodingKeys: String, CodingKey {
        case eventID = "i"
        case sportID = "si"
        case eventName = "d"
        case eventStartTime = "tt"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        eventUUID = UUID().uuidString
        eventID = try container.decodeIfPresent(String.self, forKey: .eventID)
        sportID = try container.decodeIfPresent(String.self, forKey: .sportID)
        eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        eventStartTime = try container.decodeIfPresent(TimeInterval.self, forKey: .eventStartTime)
    }
}

extension SportEvent: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(eventName)
        hasher.combine(eventID)
        hasher.combine(eventStartTime)
        hasher.combine(eventUUID)
    }
    static func == (lhs: SportEvent, rhs: SportEvent) -> Bool {
        return lhs.eventName == rhs.eventName && lhs.eventID == rhs.eventID && lhs.eventStartTime == rhs.eventStartTime && lhs.eventUUID == rhs.eventUUID
    }
}
