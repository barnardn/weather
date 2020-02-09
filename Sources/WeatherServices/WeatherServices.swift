//
//  WeatherServices.swift
//  Basic
//
//  Created by Norman Barnard on 2/8/20.
//

import Foundation

public enum WeatherServices {
    public enum OpenWeatherMap { }
    public enum ServiceErrors { }
    public enum Types { }
}

public extension Double {
    func formatted(to decimalPlaces: Int) -> String {
        return String(format: "%.*f", decimalPlaces, self)
    }
}

public protocol MetricOrImperialRepresentable {
    func description(asImperial imperial: Bool) -> String
}

extension WeatherServices.Types {

    public enum TemperatureValue: CustomStringConvertible, MetricOrImperialRepresentable {
        case kelvin(Double)
        case celcius(Double)
        case fahrenheit(Double)

        var asImperial: TemperatureValue  {
            switch self {
            case .fahrenheit:
                return self
            case .celcius(let value):
                return .fahrenheit(value * 9/5 + 32)
            case .kelvin(let value):
                return .fahrenheit((value - 273.15) * 9/5  + 32)
            }
        }

        var asMetric: TemperatureValue {
            switch self {
            case .fahrenheit(let value):
                return .celcius((value - 32) * 5 / 9)
            case .celcius:
                return self
            case .kelvin(let value):
                return .celcius(value - 273.15)
            }
        }

        public func description(asImperial imperial: Bool) -> String {
            return imperial ? self.asImperial.description : self.asMetric.description
        }

        public var description: String {
            let unit: String
            switch self {
            case .kelvin(let value):
                unit = "\(value.formatted(to: 1))°K"
            case .celcius(let value):
                unit = "\(value.formatted(to: 1))°C"
            case .fahrenheit(let value):
                unit = "\(value.formatted(to: 1))°F"
            }
            return unit
        }
    }

    enum Speed: CustomStringConvertible {

        static let conversionFactor: Double = 1.609
        case msec(Double)
        case kph(Double)
        case mph(Double)

        var description: String {
            switch self {
            case .mph(let value):
                return "\(value.formatted(to: 1)) Mph"
            case .kph(let value):
                return "\(value.formatted(to: 1)) Kph"
            case .msec(let value):
                return "\(value.formatted(to: 1)) msec"
            }
        }

        var asMetric: Speed {
            switch self {
            case .msec(let value):
                return .kph(value * 3.6)
            case .kph:
                return self
            case .mph(let value):
                return .kph(value * 1.609)
            }
        }


        var asImperial: Speed {
            switch self {
            case .msec(let value):
                return .mph(value * 2.23694)
            case .kph(let value):
                return .mph(value / 1.609)
            case .mph:
                return self
            }
        }
    }

    enum BaroPressusre: CustomStringConvertible {
        case hpa(Double)
        case psi(Double)

        var description: String {
            switch self {
            case .hpa(let value):
                return "\(value.formatted(to: 1)) hPa"
            case .psi(let value):
                return "\(value.formatted(to: 1)) psi"
            }
        }

        var asImperial: BaroPressusre {
            switch self {
            case .hpa(let value):
                return .psi(value / 6895)
            case .psi:
                return self
            }
        }

        var asMetric: BaroPressusre {
            switch self {
            case .hpa:
                return self
            case .psi(let value):
                return .hpa(value * 6895)
            }
        }

    }

}
