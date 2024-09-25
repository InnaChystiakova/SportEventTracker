//
//  SportEventList.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 22/09/2024.
//

import Foundation

struct SportEventList: Decodable {
    let sportID: String?
    let sportName: String?
    var sportEvents: [SportEvent]
    
    private enum CodingKeys: String, CodingKey {
        case sportID = "i"
        case sportName = "d"
        case sportEvents = "e"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sportID = try container.decodeIfPresent(String.self, forKey: .sportID)
        sportName = try container.decodeIfPresent(String.self, forKey: .sportName)
        sportEvents = try container.decodeIfPresent([SportEvent].self, forKey: .sportEvents) ?? []
    }
}

extension SportEventList: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(sportID)
        hasher.combine(sportName)
        hasher.combine(sportEvents)
    }
    static func == (lhs: SportEventList, rhs: SportEventList) -> Bool {
        return lhs.sportID == rhs.sportID && lhs.sportName == rhs.sportName && lhs.sportEvents == rhs.sportEvents
    }
}
