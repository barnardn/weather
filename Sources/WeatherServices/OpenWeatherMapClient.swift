//
//  OpenWeatherMapClient.swift
//  WeatherServices
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import Foundation
import Combine

public extension WeatherServices.ServiceErrors {

    enum RequestError: Error {
        case badURL(String, [URLQueryItem])
        case badResponse(URLResponse)
        case badData(Error)
    }

}

public extension WeatherServices.OpenWeatherMap {

    struct ClientConfig: CustomDebugStringConvertible {

        let apiKey: String
        let zipCode: String
        var tempOnly: Bool = false

        internal var baseURL: URL {
            return URL(string: "http://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)")!
        }

        /// designated initializer
        public init(apiKey: String, zipCode: String, tempOnly: Bool) {
            self.apiKey = apiKey
            self.zipCode = zipCode
            self.tempOnly = tempOnly
        }

        init(apiKey: String, zipCode: String) {
            self.init(apiKey: apiKey, zipCode: zipCode, tempOnly: true)
        }

        public var debugDescription: String {
            return "{ apiKey: \(apiKey), zipCode: \(zipCode), tempOnly: \(tempOnly) }"
        }
    }

    final class Client {

        private let config: ClientConfig

        public init(config: ClientConfig) {
            self.config = config
        }
        public func fetchCurrentConditions() -> AnyPublisher<CurrentConditions, WeatherServices.ServiceErrors.RequestError> {
            let zip = URLQueryItem(name: "zip", value: config.zipCode)

            guard let requestURL = config.baseURL.urlByAppending(parameters: [zip]) else {
                return Fail(
                    error: WeatherServices.ServiceErrors.RequestError.badURL(config.baseURL.absoluteString, [zip])
                ).eraseToAnyPublisher()
            }
            let publisher = URLSession.shared.dataTaskPublisher(for: requestURL)
            return publisher.tryMap { fetchData, response -> Data in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    throw WeatherServices.ServiceErrors.RequestError.badResponse(response)
                }
                return fetchData
            }
            .decode(type: WeatherServices.OpenWeatherMap.CurrentConditions.self, decoder: JSONDecoder())
            .mapError { e in
                return WeatherServices.ServiceErrors.RequestError.badData(e)
            }.eraseToAnyPublisher()
        }
    }

}

extension URL {
    func urlByAppending(parameters: [URLQueryItem]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        components.queryItems?.append(contentsOf: parameters)
        return components.url
    }

}
