//
//  WeatherService.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import Foundation
import UIKit


protocol WeatherServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void)
    func fetchCurrentWeatherIcon(iconPath: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private let baseURL = "https://api.weatherapi.com/v1"
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        print(#function)

        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=7"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("REQUEST - ", url)
            print(data)
            print(response)
            print(error)
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                print(weatherData)
                completion(.success(weatherData))
            } catch {
                completion(.failure(NetworkError.wrongData))
            }
        }.resume()
    }
    
    func fetchCurrentWeatherIcon(iconPath: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let iconUrl = URL(string: "https:\(iconPath)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: iconUrl) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(NetworkError.wrongData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case wrongData
}
