//
//  URLSessionClientTests.swift
//  SportEventTrackerTests
//
//  Created by Inna Chystiakova on 21/09/2024.
//

import XCTest
@testable import SportEventTracker

final class URLSessionClientTests: XCTestCase {
    
    //MARK: - Tests
    
    func testDoesNotPerformAnyURLRequest() {
        let session = makeSession()
        
        XCTAssertEqual(session.URLs, [])
    }
    
    func testPerformRequestWithAnyURL() async throws {
        let url = anyURL()
        let session = makeSession()
        
        XCTAssertEqual(session.URLs, [], "Precondition: shouldn't have url to start")
        
        _ = try await makeSUT(with: session).performRequest(from: url)
        
        XCTAssertEqual(session.URLs, [url])
    }
    
    func testGetFromURLFailsOnRequestError() async throws {
        let sut = makeSUT(result: .failure(anyNSError()))
        
        do {
            _ = try await sut.performRequest(from: anyURL())
            XCTFail("Expected error: \(SessionError.connectivity)")         // prevent false positive result
        } catch {
            XCTAssertEqual(error as? SessionError, SessionError.connectivity)
        }
    }
    
    func testDeliversBadResponseOnNon200HTTPResponse() async throws {
        let non200Response = (anyData(), httpResponse(statusCode: 400))
        let sut = makeSUT(result: .success(non200Response))
        
        do {
            _ = try await sut.performRequest(from: anyURL())
            XCTFail("Expected error: \(SessionError.invalidData)")              // prevent false positive result
        } catch {
            XCTAssertEqual(error as? SessionError, SessionError.invalidData)
        }
    }
    
    func testDeliversDataOn200HTTPResponse() async throws {
        let validData = anyData()
        let validResponse = anyValidURLResponse()
        let sut = makeSUT(result: .success((validData, validResponse)))
        
        let receivedData = try await sut.performRequest(from: anyURL())
        
        XCTAssertEqual(receivedData, validData)
    }

    // MARK: - Helpers
    
    private class URLSessionClientStub: SessionProtocol {
        private(set) var URLs: [URL] = []                   // to ensure, that request performs only once inside the "get" method
        let result: Result<(Data, URLResponse), Error>

        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }
        
        func get(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
            self.URLs.append(url)
            return try result.get()
        }
    }
    
    private func makeSUT(with session: URLSessionClientStub) -> URLSessionClient {
        return URLSessionClient(session: session)
    }
    
    private func makeSUT(
        result: Result<(Data, URLResponse), Error> = .success(someValidResponse())
    ) -> URLSessionClient {
        let session = URLSessionClientStub(result: result)
        let sut = URLSessionClient(session: session)
        return sut
    }
    
    private func makeSession() -> URLSessionClientStub {
        return URLSessionClientStub(result: .success(someValidResponse()))
    }
}

private func someValidResponse() -> (Data, URLResponse) {
    (anyData(), anyValidURLResponse())
}

private func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}

private func anyData() -> Data {
    return Data("any data".utf8)
}

private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

private func anyValidURLResponse() -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

private func httpResponse(statusCode: Int) -> HTTPURLResponse {
    return HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}
