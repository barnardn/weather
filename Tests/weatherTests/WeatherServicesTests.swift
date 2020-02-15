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
        hasValidLocation(location: currentConditions.coordinates)
        hasValidWindSpeed(windSpeed: currentConditions.wind)
    }

}

extension WeatherServicesTests {

    func hasValidWeather(weather: WeatherServices.OpenWeatherMap.Weather) {
        XCTAssert(weather.details == "clear sky")
        XCTAssert(weather.summary == "Clear")
        XCTAssert(weather.iconName == "01d")
    }
    
    func hasValidTemperature(temp: WeatherServices.OpenWeatherMap.Temperature) {
        XCTAssertEqual(temp.temp.celcius.formatted(to: 2), "8.85")
        XCTAssertEqual(temp.temp.fahrenheit.formatted(to: 2), "47.93")
    }
    
    func hasValidLocation(location: WeatherServices.OpenWeatherMap.Coordinates) {
        XCTAssertEqual(location.lat, 37.39)
        XCTAssertEqual(location.lon, -122.08)
    }

    func hasValidWindSpeed(windSpeed: WeatherServices.OpenWeatherMap.Wind?) {
        guard let windSpeed = windSpeed else { return XCTFail() }        
        XCTAssertEqual(windSpeed.speed.mph.formatted(to: 2), "3.36")
        XCTAssertEqual(windSpeed.speed.kph.formatted(to: 1), "5.4")
        XCTAssertEqual(windSpeed.direction, 350)
    }
    
}
