//
//  APIService.swift
//  MovieDB
//
//  Created by le.n.t.trung on 07/11/2022.
//

import Foundation

final class APICaller {

    static let shared = APICaller()
    private let session: URLSession
    private let imageCache = NSCache<NSString, AnyObject>()

    private var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "TMDBInfo", ofType: "plist") else {
          fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
        }
        return value
      }
    }

    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }

    func getJSON<T: Codable>(urlApi: String, method: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlApi + "?api_key=\(apiKey)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method

        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

            if let error = error {
                completion(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, RequestError.badResponse)
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, RequestError.badStatusCode(httpResponse.statusCode))
                return
            }

            guard let data = data else {
                completion(nil, RequestError.badData)
                return
            }

            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(results, nil)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    func getImage(imageURL: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: imageURL) else {
            completion(nil, RequestError.badData)
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? Data {
            completion(cachedImage, nil)
            return
        } else {
            let task = session.downloadTask(with: url) { (localUrl: URL?, response: URLResponse?, error: Error?) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, RequestError.badResponse)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, RequestError.badStatusCode(httpResponse.statusCode))
                    return
                }

                guard let localUrl = localUrl else {
                    completion(nil, RequestError.badData)
                    return
                }

                do {
                    let data = try Data(contentsOf: localUrl)
                    self.imageCache.setObject(data as AnyObject, forKey: url.absoluteString as NSString)
                    completion(data, nil)
                } catch let error {
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
