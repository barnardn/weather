//
//  OpenWeatherMapClient.swift
//  WeatherServices
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import Foundation
import SystemConfiguration

public extension WeatherServices.ServiceErrors {

    enum RequestError: Error {
        case badURL(String, [URLQueryItem])
        case badResponse(URLResponse)
        case badData(Error)
    }

}

public extension WeatherServices.OpenWeatherMap {

    struct ClientConfig: CustomDebugStringConvertible {

        static let host = "api.openweathermap.org"
        
        let apiKey: String
        let zipCode: String

        internal var baseURL: URL {
            return URL(string: "http://\(Self.host)/data/2.5/weather?appid=\(apiKey)")!
        }

        /// designated initializer
        public init(apiKey: String, zipCode: String) {
            self.apiKey = apiKey
            self.zipCode = zipCode
        }

        public var debugDescription: String {
            return "{ apiKey: \(apiKey), zipCode: \(zipCode) }"
        }
    }

    final class Client {

        private let config: ClientConfig

        public init(config: ClientConfig) {
            self.config = config
        }

        public func fetchCurrentConditions2() async throws -> CurrentConditions {
            let zip = URLQueryItem(name: "zip", value: config.zipCode)

            guard let requestURL = config.baseURL.urlByAppending(parameters: [zip]) else {
                throw WeatherServices.ServiceErrors.RequestError.badURL(config.baseURL.absoluteString, [zip])
            }

            let (data, response) = try await URLSession.shared.data(from: requestURL)
            guard
                let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                throw WeatherServices.ServiceErrors.RequestError.badResponse(response)
            }

            do {
                let jsonDecoder = JSONDecoder()
                return try jsonDecoder.decode(WeatherServices.OpenWeatherMap.CurrentConditions.self, from: data)
            } catch  {
                throw WeatherServices.ServiceErrors.RequestError.badData(error)
            }
        }
        
        
        public func isApiReachable() -> Bool {
            guard let reachabilityTarget = SCNetworkReachabilityCreateWithName(nil, ClientConfig.host) else { return false }
            var flags = SCNetworkReachabilityFlags()
            guard SCNetworkReachabilityGetFlags(reachabilityTarget, &flags) == true else { return false }
            return flags.contains(.reachable)
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
