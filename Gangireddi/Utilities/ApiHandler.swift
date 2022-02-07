//
//  ApiHandler.swift
//  Gangireddi
//
//  Created by Sandeep on 01/02/22.
//
import UIKit

enum NetworkError: Error {
    case inValidUrl(String)
    case unableToComplete
    case inValidResponse
    case inValidData
}
//https://jsonplaceholder.typicode.com/users
//https://itunes.apple.com/search/media=music&entity=song&term=Music
class ApiHandler {
    func callApi(completionHandler:@escaping (Result<Results,NetworkError>)->()) {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        guard let url = URL(string: "https://itunes.apple.com/search/media=music&entity=song&term=Music") else {
            completionHandler(.failure(.inValidUrl("Please check your url")))
            return
        }
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, response, error) in
            
            let decoder = JSONDecoder()
            do {
                guard let data = data else {
                    completionHandler(.failure(.inValidData))
                    return
                }
                let result = try decoder.decode(Results.self, from: data)
                print(result)
                completionHandler(.success(result))
            } catch(let error) {
                print(error.localizedDescription)
            }
        })
        dataTask?.resume()
    }
    
}
