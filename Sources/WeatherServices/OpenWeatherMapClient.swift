//
//  OpenWeatherMapClient.swift
//  WeatherServices
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import Foundation
import Combine

public extension WeatherServices.OpenWeatherMap {

    struct ClientConfig: CustomDebugStringConvertible {
        let apiKey: String
        let zipCode: String
        var tempOnly: Bool = false

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

        init(config: ClientConfig) {
            self.config = config
        }

    }



}


