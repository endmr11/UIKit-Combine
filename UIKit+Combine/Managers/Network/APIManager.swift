//
//  APIManager.swift
//  UIKit+Combine
//
//  Created by Eren Demir on 1.04.2023.
//

import Foundation
import Combine

//MARK: - INTERFACE
protocol IAPIManager {
    func get<T:Codable>(endpoint: Endpoint) -> AnyPublisher<Result<T,APIError>,Never>
}

final class APIManager: IAPIManager {
    static let shared = APIManager()
    func get<T:Codable>(endpoint: Endpoint) -> AnyPublisher<Result<T,APIError>, Never> {
        return URLSession
            .shared
            .dataTaskPublisher(for: URL(string: endpoint.url)!)
            .receive(on: DispatchQueue.main)
            .mapError { _ in fatalError() }
            .flatMap{ data , response ->AnyPublisher<Result<T,APIError>, Never>  in
                guard let response = response as? HTTPURLResponse else {
                    return Just(.failure(APIError.decodingError))
                        .eraseToAnyPublisher()
                }
                if(200...226).contains(response.statusCode){
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: T.self, decoder: jsonDecoder)
                        .mapError { _ in fatalError() }
                        .map({ val in
                                .success(val)
                        })
                        .eraseToAnyPublisher()
                }else{
                    return Just(.failure(APIError.decodingError))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

