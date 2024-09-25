//
//  SportEventWrapper.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 24/09/2024.
//

import Foundation

class SportEventWrapper: Hashable, Equatable {
    var sportEvent: SportEvent
    var isFavorite: Bool
    
    init(sportEvent: SportEvent, isFavorite: Bool = false) {
        self.sportEvent = sportEvent
        self.isFavorite = isFavorite
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sportEvent)
        hasher.combine(isFavorite)
    }
    
    static func == (lhs: SportEventWrapper, rhs: SportEventWrapper) -> Bool {
        return lhs.sportEvent == rhs.sportEvent && lhs.isFavorite == rhs.isFavorite
    }
}
