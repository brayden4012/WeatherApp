//
//  WeatherDataController.swift
//  Weather
//
//  Created by Brayden Harris on 6/11/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDataController {
    static let baseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather")
    static let baseImageURL = URL(string: "http://openweathermap.org/img/w")
    
    static func fetchWeatherData(byCityID cityID: String, completion: @escaping ((WeatherData?) -> Void)) {
        guard let baseURL = baseURL else { completion(nil); return }

        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { print("Error fetching URLComponents"); completion(nil); return }
        
        let idQuery = URLQueryItem(name: "id", value: cityID)
        let apiKeyQuery = URLQueryItem(name: "APPID", value: "ebf711ecad02867424a26651a86d417e")
        
        components.queryItems = [idQuery, apiKeyQuery]
        
        guard let finalURL = components.url else { completion(nil); return }
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error fetching weather data from API: \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data found from API")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("Error decoding weather data from JSON: \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
    
    static func fetchWeatherData(byLocation location: CLLocation, completion: @escaping ((WeatherData?) -> Void)) {
        guard let baseURL = baseURL else { completion(nil); return }
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { print("Error fetching URLComponents"); completion(nil); return }
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        let latQuery = URLQueryItem(name: "lat", value: String(lat))
        let lonQuery = URLQueryItem(name: "lon", value: String(lon))
        let apiKeyQuery = URLQueryItem(name: "APPID", value: "ebf711ecad02867424a26651a86d417e")


        components.queryItems = [latQuery, lonQuery, apiKeyQuery]
        
        guard let finalURL = components.url else { completion(nil); return }
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error fetching weather data from API: \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data found from API")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("Error decoding weather data from JSON: \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
        }
        dataTask.resume()
    }
    
    static func fetchIconFor(weatherData: WeatherData, completion: @escaping ((UIImage?) -> Void)) {
        guard let baseURL = baseImageURL, let weather = weatherData.weather.first else { completion(nil); return }

        let iconID = weather.iconID
        
        let finalURL = baseURL.appendingPathComponent(iconID).appendingPathExtension("png")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error fetching icon for \(weatherData.city): \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data found for \(weatherData.city)'s icon")
                completion(nil)
                return
            }
            
            let icon = UIImage(data: data)
            completion(icon)
            }.resume()
    }
}
