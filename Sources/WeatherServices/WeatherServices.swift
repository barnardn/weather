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

public protocol MetricOrImperialMeasurable {
    func toImperial(_ imperial: Bool) -> Double
}

extension WeatherServices.Types {

    public struct TemperatureValue: MetricOrImperialMeasurable, MetricOrImperialRepresentable {
        private let kelvin: Double

        var celcius: Double { kelvin - 273.15 }
        var fahrenheit: Double { celcius * 9/5 + 32.0 }
        
        public init(kelvin: Double) {
            self.kelvin = kelvin
        }

        public func toImperial(_ imperial: Bool) -> Double {
            imperial ? fahrenheit : celcius
        }
        
        public func description(asImperial imperial: Bool) -> String {
            "\(toImperial(imperial).formatted(to: 2))\(imperial ? "°F" : "°C")"
        }
        
    }
    
    struct Speed: MetricOrImperialMeasurable, MetricOrImperialRepresentable {
        private let metersPerSec: Double

        var kph: Double { metersPerSec * 3.6 }
        var mph: Double { metersPerSec * 2.23694 }
        
        init(metersPerSec: Double) {
            self.metersPerSec = metersPerSec
        }
        
        public func toImperial(_ imperial: Bool) -> Double {
            imperial ? mph : kph
        }
        
        public func description(asImperial imperial: Bool) -> String {
            "\(toImperial(imperial).formatted(to: 2))\(imperial ? "mph" : "kph")"
        }
    }
    
    struct BaroPressusre: MetricOrImperialMeasurable, MetricOrImperialRepresentable {
        let hpa: Double
        var psi: Double { hpa / 6895.0 }

        public init(hpa: Double) {
            self.hpa = hpa
        }

        public func toImperial(_ imperial: Bool) -> Double {
            imperial ? psi : hpa
        }
        
        public func description(asImperial imperial: Bool) -> String {
            "\(toImperial(imperial).formatted(to: 2))\(imperial ? "psi" : "hpa")"
        }

        
    }

}
