//
//  WeatherData.swift
//  Weather
//
//  Created by Brayden Harris on 6/11/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    let city: String
    let temperature: Temp
    let weather: [Weather]
    let wind: Wind
    let clouds: Clouds
    
    enum CodingKeys: String, CodingKey {
        case city = "name"
        case temperature = "main"
        case weather
        case wind
        case clouds
    }
}

struct Temp: Codable {
    let temperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

struct Weather: Codable {
    let iconID: String
    
    enum CodingKeys: String, CodingKey {
        case iconID = "icon"
    }
}

struct Wind: Codable {
    let wind: Double
    
    enum CodingKeys: String, CodingKey {
        case wind = "speed"
    }
}

struct Clouds: Codable {
    let clouds: Int
    
    enum CodingKeys: String, CodingKey {
        case clouds = "all"
    }
}
