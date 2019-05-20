//
//  WeatherData.swift
//  Weather App
//
//  Created by Soumil on 23/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let sys: Sys
    let weather: [Weather]
    let clouds: Clouds
    let id, dt: Int
    let main: Main
    let coord: Coord
    let visibility: Int
    let wind: Wind
    let cod: Int
    let base: String
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    let humidity: Int
    let temp, tempMax, tempMin: Double
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case humidity, temp
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case pressure
    }
}

struct Sys: Codable {
    let country: String
    let type, sunrise, id, sunset: Int
    let message: Double
}

struct Weather: Codable {
    let description, main: String
    let id: Int
    let icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
