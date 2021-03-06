//
//  ServiceLayer.swift
//  ConcreteChallenge
//
//  Created by Kaique Damato on 10/1/20.
//  Copyright © 2020 KiQ. All rights reserved.
//

import Foundation

protocol ServiceLayerProtocol: class {
    func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ())
}

class ServiceLayer: ServiceLayerProtocol {
    
    func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard response != nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            let responseObject = try! JSONDecoder().decode(T.self, from: data)
            
            DispatchQueue.main.async {
                completion(.success(responseObject))
            }
        }
        
        dataTask.resume()
    }
}

class ServiceLayerMock: ServiceLayerProtocol {
    func request<T: Codable>(router: Router, completion: @escaping (Result<T, Error>) -> ()) {
        var filePath = ""
        
        switch router {
        case .getMovies:
            filePath = "MoviesResponse"
        case .getGenres:
            filePath = "GenreResponse"
        }
        
        MockApiClient.loadJSONDataFromFile(filePath: filePath) { (result: Result<Data, Error>) in
            switch result {
            case .success(let response):
                let responseObject = try! JSONDecoder().decode(T.self, from: response)
                completion(.success(responseObject))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
