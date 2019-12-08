//
//  RequestAgent.swift
//  SwiftUICheatSheet
//
//  Created by Erez Mizrahi on 03/12/2019.
//  Copyright © 2019 Erez Mizrahi. All rights reserved.
//

import Foundation
import Combine

struct RequestAgent {
    
    static let shared = RequestAgent()
    
    private let session = URLSession.shared
    
    struct HTTPResponse<T> {
        let data: T
        let response: URLResponse
    }
    
    func run<T:Codable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<HTTPResponse<T>,Error> {
        return session.dataTaskPublisher(for: request)
            .mapError({ (err) -> Error in
                print(err)
                return err
            })
          .tryMap {
            let value = try decoder.decode(T.self, from: $0.data)
            print(value)
            return HTTPResponse(data: value, response: $0.response)
            }
        .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
    }
}
