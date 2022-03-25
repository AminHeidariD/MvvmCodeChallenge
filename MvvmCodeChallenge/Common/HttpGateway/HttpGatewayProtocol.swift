//
//  HttpGatewayProtocol.swift
//  MvvmCodeChallenge
//
//  Created by amin heidari on 3/25/22.
//

import Foundation
import Combine

protocol HttpGatewayProtocol {
    func getRequest(url: URL) -> AnyPublisher<Data?, URLError>
}
