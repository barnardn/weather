//
//  OpenWeatherMapModels.swift
//  Basic
//
//  Created by Norman Barnard on 2/8/20.
//

import Foundation
import CoreLocation

extension WeatherServices.OpenWeatherMap {

    struct CurrentConditions: Decodable {
        var id: Int
        var cityName: String
        var timeZoneOffset: Int
        var visibility: Int

        var sysInfo: Sys
        var coordinates: Coordinates
        var weather: [Weather]
        var temperature: Temperature
        var clouds: Clouds?
        var wind: Wind?
        var rain: VolumeOverTime?
        var snow: VolumeOverTime?

        private enum CodingKeys: String, CodingKey {
            case id, visibility, weather, clouds, rain, wind, snow
            case cityName = "name"
            case timeZoneOffset = "timezone"
            case temperature = "main"
            case sysInfo = "sys"
            case coordinates = "coord"
        }
    }


    struct Weather: Decodable {
        var id: Int
        var summary: String
        var details: String
        var iconName: String

        private enum CodingKeys: String, CodingKey {
            case id
            case summary = "main"
            case details = "description"
            case iconName = "icon"
        }
    }

    struct Temperature: Decodable {
        var temp: Double
        var feelsLike: Double
        var minTemp: Double
        var maxTemp: Double
        var pressure: Int
        var humidity: Int

        private enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
            case pressure
            case humidity
        }
    }

    struct Coordinates: Decodable {
        var lat: Double
        var lon: Double

        var toCoreLocation: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }

    struct Clouds: Decodable {
        var percent: Double

        private enum CodingKeys: String, CodingKey {
            case percent = "all"
        }
    }

    struct Wind: Decodable {
        var speed: Double
        var direction: Double

        private enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }
    }

    struct Sys: Decodable {
        var country: String
        var sunrise: TimeInterval
        var sunset: TimeInterval
    }

    // rain and snow
    internal struct VolumeOverTime: Decodable {
        var oneHour: Double
        var threeHour: Double

        private enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }




}
