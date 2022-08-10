//
//  weather.swift
//  weather
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import ArgumentParser
import Foundation
import TSCBasic
import WeatherServices
import TSCUtility

@main
@available(macOS 12.0, *)
struct WeatherCommand: AsyncParsableCommand {
    
    @Flag(name: .shortAndLong, help: "returns only the temperature")
    var justTemp = false
    
    @Flag(name: .shortAndLong, help: "display metric values")
    var metric = false
 
    @Argument(help: "5 digit zip code")
    var zipCode: String
}

extension String: Error {}

@available(macOS 12.0, *)
extension WeatherCommand {
    
    mutating func run() async throws {
        guard let apiKey = ProcessEnv.vars["OPENWEATHERMAP_API"] else {
            throw "Missing Environment Variable: set the OPENWEATHERMAP_API environment variable to your api key."
        }
        let clientConfig = WeatherServices.OpenWeatherMap.ClientConfig(apiKey: apiKey, zipCode: zipCode)
        let openWeatherMap = WeatherServices.OpenWeatherMap.Client(config: clientConfig)
        guard openWeatherMap.isApiReachable() else {
            throw "You must be connected to the Internet. No connection is currently available."
        }

        do {
            let conditions = try await openWeatherMap.fetchCurrentConditions2()
            if justTemp {
                print(conditions.currentTemperature.description(asImperial: !metric))
            } else {
                print("\(conditions.description(asImperial: !metric))")
            }
        } catch {
            print("Failed to get weather \(error)")
        }
    }
}
