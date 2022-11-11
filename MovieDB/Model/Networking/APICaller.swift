//
//  APIService.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation

final class APICaller {

    static let shared = APICaller()
    private let network = Network.shared
    private let session: URLSession
    private let imageCache = NSCache<NSString, AnyObject>()

    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "TMDBInfo", ofType: "plist"),
                  let value = NSDictionary(contentsOfFile: filePath)?.object(forKey: "API_KEY") as? String else {
                return "Couldn't find API Key"
            }
            return value
        }
    }

    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    func request<T: Codable>(urlString: String, method: String, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString + "?api_key=\(apiKey)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method

        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RequestError.badResponse))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(RequestError.badStatusCode(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(RequestError.badData))
                return
            }

            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func getImage(imageURL: String, completion: @escaping(Result<Data, Error>) -> Void) {
        if let cachedImage = imageCache.object(forKey: imageURL as NSString) as? Data {
            completion(.success(cachedImage))
            return
        }
        let urlString = network.loadImageURL() + imageURL
        guard let url = URL(string: urlString) else {
            completion(.failure(RequestError.badData))
            return
        }
        let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(RequestError.badResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(RequestError.badStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let localUrl = localUrl else {
                completion(.failure(RequestError.badData))
                return
            }
            
            do {
                let data = try Data(contentsOf: localUrl)
                self.imageCache.setObject(data as AnyObject, forKey: imageURL as NSString)
                completion(.success(data))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
