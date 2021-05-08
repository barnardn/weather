//
//  main.swift
//  weather
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import ArgumentParser
import Foundation
import Combine
import TSCBasic
import WeatherServices

@available(OSX 10.15, *)

extension String: Error {}

var cancellable: AnyCancellable?

struct WeatherCommand: ParsableCommand {
    
    @Flag(name: .shortAndLong, help: "returns only the temperature")
    var justTemp = false
    
    @Flag(name: .shortAndLong, help: "display metric values")
    var metric = false
 
    @Argument(help: "5 digit zip code")
    var zipCode: String
    
    mutating func run() throws {
        
        guard let apiKey = ProcessEnv.vars["OPENWEATHERMAP_API"] else {
            throw "Missing Environment Variable: set the OPENWEATHERMAP_API environment variable to your api key."
        }
        let clientConfig = WeatherServices.OpenWeatherMap.ClientConfig(apiKey: apiKey, zipCode: zipCode)
        let openWeatherMap = WeatherServices.OpenWeatherMap.Client(config: clientConfig)
        guard openWeatherMap.isApiReachable() else {
            throw "You must be connected to the Internet. No connection is currently available."
        }
        
        let waitSemaphore = DispatchSemaphore(value: 0)

        cancellable = openWeatherMap.fetchCurrentConditions()
            .sink(receiveCompletion: { completionEvent in
                defer { waitSemaphore.signal() }
                if case .failure(let error) = completionEvent {
                    print("Failed to get weather \(error)")
                }
            }) { [justTemp, metric] currentConditions in
                if justTemp {
                    print(currentConditions.currentTemperature.description(asImperial: !metric))
                } else {
                    print("\(currentConditions.description(asImperial: !metric))")
                }
            }

        waitSemaphore.wait()
    }
}

if #available(OSX 10.15, *) {
    WeatherCommand.main()
} else {
    print("Update to a macos 10.15 or better")
    exit(1)
}
