//
//  OpenWeatherMapClient.swift
//  WeatherServices
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import Foundation

public struct OpenWeatherMapConfiguration: CustomDebugStringConvertible {

    let apiKey: String
    let zipCode: String
    var tempOnly: Bool = false

    public init(apiKey: String, zipCode: String, tempOnly: Bool = false) {
        self.apiKey = apiKey
        self.zipCode = zipCode
        self.tempOnly = tempOnly
    }
    public var debugDescription: String {
        return "{ apiKey: \(apiKey), zipCode: \(zipCode), tempOnly: \(tempOnly) }"
    }

}
