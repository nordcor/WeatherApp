//
//  WeatherProtocols.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

protocol WeatherViewProtocol: AnyObject {
    func displayWeather(_ weather: WeatherData)
    func displayError(_ message: String)
    func showLoading()
    func hideLoading()
}

protocol WeatherPresenterProtocol {
    func viewDidLoad()
    func retryFetchWeather()
}
