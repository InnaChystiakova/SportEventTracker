//
//  SportEventViewModel.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 23/09/2024.
//

import Foundation

class SportEventViewModel {
    var onEventsReceived: (([SportEventList]) -> Void)?
    var onErrorReceived: ((String) -> Void)?
    
    private let apiURLString = "https://0083c2a8-dfe1-4a25-a7f7-8cc32f1de2c3.mock.pstmn.io/api/sports"
    private let sessionClient: URLSessionClient

    init(sessionClient: URLSessionClient = URLSessionClient()) {
        self.sessionClient = sessionClient
    }
    
    func fetchSportsData() async {
        guard let url = URL(string: apiURLString) else {
            onErrorReceived?(SessionError.badURL.description)
            return
        }
        
        do {
            let data = try await sessionClient.performRequest(from: url)
            let sportsData = try JSONDecoder().decode([SportEventList].self, from: data)
            onEventsReceived?(sportsData)
        } catch {
            guard let error = error as? SessionError else {
                onErrorReceived?(error.localizedDescription)
                return
            }
            onErrorReceived?(error.description)
        }
    }
}
