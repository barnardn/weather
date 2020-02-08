//
//  main.swift
//  weather
//
//  Created by Norman Barnard on 2/4/20.
//  Copyright © 2020 normbarnard.com. All rights reserved.
//

import Foundation
import SPMUtility
import Basic
import WeatherServices


let argParser = ArgumentParser(commandName: "weather", usage: "<flags> ZipCode", overview: "returns the current weather")
let temperatureOnlyArg = argParser.add(option: "--just-temp", shortName: "-j", kind: Bool.self, usage: "return only the temperature", completion: ShellCompletion.none)
let zipCodeArg = argParser.add(positional: "ZipCode", kind: String.self, optional: false, usage: "5 digit zip code", completion: ShellCompletion.none)

let argv = Array(CommandLine.arguments.dropFirst())
do {
    let parsedArgs = try argParser.parse(argv)
    guard let zipCode = parsedArgs.get(zipCodeArg) else { exit(-1) }

    let temp = parsedArgs.get(temperatureOnlyArg) ?? false

    guard let apiKey = ProcessInfo.processInfo.environment["OPENWEATHERMAP_API"] else {
        argParser.printUsage(on: Basic.stderrStream)
        print("\nMissing Environment Variable: set the OPENWEATHERMAP_API environment variable to your api key.\n\n")
        exit(-1)
    }
    let clientConfig = WeatherServices.OpenWeatherMap.ClientConfig(apiKey: apiKey, zipCode: zipCode, tempOnly: temp)
    print("Configuration: \(clientConfig)")

} catch ArgumentParserError.expectedValue(let option) {
    print("Missing value for argument \(option)")
} catch ArgumentParserError.expectedArguments(let parser,let missingArgs) {
    print("\(parser) missing: \(missingArgs.joined())")
} catch {
    print(error.localizedDescription)
}
