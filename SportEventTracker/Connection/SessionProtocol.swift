//
//  SessionProtocol.swift
//  SportEventTracker
//
//  Created by Inna Chystiakova on 21/09/2024.
//

import Foundation

public enum SessionClientResult {
    case success(Data, URLResponse)
    case failure(Error)
}

public protocol SessionProtocol {
    func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: SessionProtocol {
    public func get(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: delegate)
    }
}
