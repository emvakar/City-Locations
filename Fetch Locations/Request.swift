//
//  Request.swift
//  Fetch Locations
//
//  Created by Emil Karimov on 09/08/2019.
//  Copyright © 2019 TAXCOM. All rights reserved.
//

import Foundation

class Request {

    static let shared = Request()


    func fetchCity(name: String) -> (Result?, String, Error?) {

        let headers = [
            "User-Agent": "PostmanRuntime/7.15.2",
            "Accept": "*/*",
            "Host": "api.opencagedata.com",
            "Accept-Encoding": "gzip, deflate",
            "Connection": "keep-alive"
        ]

        let urlString = "https://api.opencagedata.com/geocode/v1/json?key=27785931bc004436b3918cf1e490df15&q=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: urlString) else { return (nil, name, nil) }

        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared

        let resp = session.synchronousDataTask(with: url)
        if let data = resp.0 {
            do {
                let mapResponse = try JSONDecoder().decode(MapResponse.self, from: data)
                if let result = mapResponse.results.first {//.first(where: { $0.components.type == "city" }) {
                    return (result, name, nil)
                }
            } catch {
                print(error)
                return (nil, name, error)
            }
        }
        return (nil, name, resp.2)
    }
}

extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }
}
