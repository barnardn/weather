//
//  OpenWeatherMapModels.swift
//  Basic
//
//  Created by Norman Barnard on 2/8/20.
//

import Foundation
import CoreLocation

extension WeatherServices.OpenWeatherMap {

    public struct CurrentConditions: Decodable {

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
        var temp: WeatherServices.Types.TemperatureValue
        var feelsLike: WeatherServices.Types.TemperatureValue
        var minTemp: WeatherServices.Types.TemperatureValue
        var maxTemp: WeatherServices.Types.TemperatureValue
        var pressure: WeatherServices.Types.BaroPressusre
        var humidity: Int

        private enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
            case pressure
            case humidity
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let tempK = try container.decode(Double.self, forKey: .temp)
            let feelsK = try container.decode(Double.self, forKey: .feelsLike)
            let minK = try container.decode(Double.self, forKey: .minTemp)
            let maxK = try container.decode(Double.self, forKey: .minTemp)
            temp = .kelvin(tempK)
            feelsLike = .kelvin(feelsK)
            minTemp = .kelvin(minK)
            maxTemp = .kelvin(maxK)
            let baroInMetric = try container.decode(Int.self, forKey: .pressure)
            pressure = .hpa(Double(baroInMetric))
            humidity = try container.decode(Int.self, forKey: .humidity)
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
        var speed: WeatherServices.Types.Speed
        var direction: Double

        private enum CodingKeys: String, CodingKey {
            case speed
            case direction = "deg"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let speedK = try container.decode(Double.self, forKey: .speed)
            speed = .kph(speedK)
            direction = try container.decode(Double.self, forKey: .direction)
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
        func imperial() -> VolumeOverTime {
            let factor: Double = 0.0393701
            return VolumeOverTime(
                oneHour: oneHour * factor,
                threeHour: threeHour * factor
            )
        }

    }

}

// MARK: CustomStringConvertible

extension WeatherServices.OpenWeatherMap.CurrentConditions: MetricOrImperialRepresentable {
    public func description(asImperial imperial: Bool) -> String {
        let components = [
            "\t" + coordinates.description,
            "\t" + sysInfo.description,
            weather.map { $0.description }.joined(separator: ","),
            clouds?.description,
            temperature.description(asImperial: imperial),
            wind?.description(asImperial: imperial),
            rain?.description,
            snow?.description
        ]
        .compactMap { $0 }
        .joined(separator: "\n")

        return
            """
            Current Conditions for \(cityName), \(sysInfo.country)
            \(components)
            """
    }
}

extension WeatherServices.OpenWeatherMap.Weather: CustomStringConvertible {
    var description: String { "\(summary): \(details)" }
}


extension WeatherServices.OpenWeatherMap.Temperature: MetricOrImperialRepresentable {
    public func description(asImperial imperial: Bool) -> String {
        return
            """
            Temperature:
            \tCurrent: \(imperial ? temp.asImperial : temp.asMetric)
            \tFeels Like: \(imperial ? feelsLike.asImperial : feelsLike.asMetric)
            \tMin: \(imperial ? minTemp.asImperial : minTemp.asMetric) Max: \(imperial ? maxTemp.asImperial : maxTemp.asMetric)
            \tHumidity: \(humidity)%
            \tPressure: \(imperial ? pressure.asImperial : pressure.asMetric)
            """
    }
}

extension WeatherServices.OpenWeatherMap.Wind: MetricOrImperialRepresentable {
    public func description(asImperial imperial: Bool) -> String {
        return
            """
            Wind:
            \t\(imperial ? speed.asImperial : speed.asMetric) at \(direction)°
            """
    }
}

extension WeatherServices.OpenWeatherMap.Coordinates: CustomStringConvertible {
    var description: String {
        return "(\(lat.formatted(to: 4))° Latitude, \(lon.formatted(to: 4))° Longitude)"
    }
}

extension WeatherServices.OpenWeatherMap.Clouds: CustomStringConvertible {
    var description: String { "Cloud cover: \(percent.formatted(to: 0))%" }
}

extension WeatherServices.OpenWeatherMap.VolumeOverTime: CustomStringConvertible {
    var description: String {
        let imperial = self.imperial()
        return
            """
            1 Hour: \(imperial.oneHour) in/hour
            3 Hour: \(imperial.threeHour) in/hour
            """
    }
}

extension WeatherServices.OpenWeatherMap.Sys: CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeStyle = .medium
        let fmtSunrise = dateFormatter.string(from: Date(timeIntervalSince1970: sunrise))
        let fmtSunset = dateFormatter.string(from: Date(timeIntervalSince1970: sunset))
        return "Sunrise: \(fmtSunrise) Sunset: \(fmtSunset)"
    }
}
