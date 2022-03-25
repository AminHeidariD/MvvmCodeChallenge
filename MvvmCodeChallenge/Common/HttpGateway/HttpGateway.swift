//
//  HttpGateway.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/13/22.
//

import Foundation
import Combine

class HttpGateway: HttpGatewayProtocol {
    func getRequest(url: URL) -> AnyPublisher<Data?, URLError> {
        return URLSession.shared.dataTaskPublisher(for: url).map { $0.data }
        .eraseToAnyPublisher()
    }
}
