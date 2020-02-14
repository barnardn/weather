//
//  WeatherServicesTests.swift
//  weatherTests
//
//  Created by Norman Barnard on 2/8/20.
//

import Foundation
import XCTest
@testable import WeatherServices

class WeatherServicesTests: XCTestCase {

    static let apiKey = "SomeApiKey"
    static let defaultZip = "49002"
    var standardConfig = WeatherServices.OpenWeatherMap.ClientConfig(apiKey: apiKey, zipCode: defaultZip)

    var currentConditionsData: Data {
        let path = URL(fileURLWithPath: #file).deletingLastPathComponent()
        let jsonFile = path.appendingPathComponent("current-conditions.json")
        return try! Data(contentsOf: jsonFile)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeserialize() {
        let jsonDecoder = JSONDecoder()
        let currentConditions = try! jsonDecoder.decode(
            WeatherServices.OpenWeatherMap.CurrentConditions.self,
            from: currentConditionsData
        )
        XCTAssertNotNil(currentConditions)
        XCTAssertEqual(currentConditions.cityName, "Mountain View")
        hasValidWeather(weather: currentConditions.weather.first!)
        hasValidTemperature(temp: currentConditions.temperature)
    }

}


extension WeatherServicesTests {

    func hasValidWeather(weather: WeatherServices.OpenWeatherMap.Weather) {
        XCTAssert(weather.details == "clear sky")
        XCTAssert(weather.summary == "Clear")
        XCTAssert(weather.iconName == "01d")
    }
    
    func hasValidTemperature(temp: WeatherServices.OpenWeatherMap.Temperature) {
        switch (temp.temp.asMetric, temp.temp.asImperial) {
        case (.celcius(let celVal), .fahrenheit(let farVal)):
            XCTAssertEqual(celVal.rounded(.up), 9)
            XCTAssertEqual(farVal.rounded(.up), 48)
        default:
            XCTFail()
        }
    }

}
