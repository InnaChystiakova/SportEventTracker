//
//  URLSessionClient.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 21/09/2024.
//

import Foundation

public enum SessionError: Error {
    case badURL
    case connectivity
    case invalidData
    
    var description: String {
        switch self {
        case .badURL:
            return "Bad url received"
        case .connectivity:
            return "Something wrong with the network"
        case .invalidData:
            return "Invalid data received"
        }
    }
}

public class URLSessionClient {
    private let session: SessionProtocol
    
    public init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }

    public func performRequest(from url: URL) async throws -> Data {
        guard let (data, response) = try? await session.get(from: url, delegate: nil) else {
            throw SessionError.connectivity
        }
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SessionError.invalidData
        }
        
        return data
    }
}

