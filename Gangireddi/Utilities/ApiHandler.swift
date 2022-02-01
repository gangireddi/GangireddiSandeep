//
//  ApiHandler.swift
//  Gangireddi
//
//  Created by Sandeep on 01/02/22.
//
import UIKit

enum NetworkError: Error {
    case badURL
    case badData
}

class ApiHandler {
    func callApi(completionHandler:@escaping (Result<Results,NetworkError>)->()) {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        guard let url = URL(string: "https://itunes.apple.com/search/media=music&entity=song&term=Music") else {
            completionHandler(.failure(.badURL))
            return
        }
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            let decoder = JSONDecoder()
            do {
                guard let data = data else {
                    completionHandler(.failure(.badData))
                    return
                }
                let result = try decoder.decode(Results.self, from: data)
                completionHandler(.success(result))
            } catch {
                
            }
            
            
        })
        dataTask?.resume()
        
        
    }
}
