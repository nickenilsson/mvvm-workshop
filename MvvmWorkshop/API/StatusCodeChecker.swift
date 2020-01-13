//
//  ApiClient.swift
//  MvvmWorkshop
//
//  Created by Niklas Nilsson on 2020-01-13.
//  Copyright © 2020 Sveriges Radio AB. All rights reserved.
//

import Foundation

struct StatusCodeChecker {

    enum StatusCodeCheckerError: Error {
        case noResponse
        case notHTTP
    }

    static func check(url: URL, completion: @escaping (Result<Int, Error>) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let response = response else {
                completion(.failure(StatusCodeCheckerError.noResponse))
                return
            }

            guard let httpResponse = (response as? HTTPURLResponse) else {
                completion(.failure(StatusCodeCheckerError.notHTTP))
                return
            }
            completion(.success(httpResponse.statusCode))

        }).resume()
    }

}
