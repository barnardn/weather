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
        let jsonFile = Bundle(for: WeatherServicesTests.self).url(forResource: "current-conditions", withExtension: "json")
        return try! Data(contentsOf: jsonFile!)
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
        XCTAssert(currentConditions.cityName == "Mountain View")
        hasValidWeather(weather: currentConditions.weather.first!)
        hasValidTemp(temperature: currentConditions.temperature)
    }

}


extension WeatherServicesTests {

    func hasValidWeather(weather: WeatherServices.OpenWeatherMap.Weather) {
        XCTAssert(weather.details == "clear sky")
        XCTAssert(weather.summary == "Clear")
        XCTAssert(weather.iconName == "01d")
    }

    func hasValidTemp(temperature: WeatherServices.OpenWeatherMap.Temperature) {
        XCTAssert(temperature.temp.rounded() == 283, "expected 283, got \(temperature.temp.rounded())")
        XCTAssert(temperature.feelsLike.rounded() == 282, "expected 282, got \(temperature.feelsLike.rounded())")
    }


}
