//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import Foundation

class WeatherPresenter: WeatherPresenterProtocol {
    weak var view: WeatherViewProtocol?
    private let weatherService: WeatherServiceProtocol
    private let locationService: LocationServiceProtocol
    
    init(view: WeatherViewProtocol,
         weatherService: WeatherServiceProtocol = WeatherService(),
         locationService: LocationServiceProtocol = LocationService()) {
        self.view = view
        self.weatherService = weatherService
        self.locationService = locationService
    }
    
    func viewDidLoad() {
        requestLocationAndFetchWeather()
    }
    
    func retryFetchWeather() {
        requestLocationAndFetchWeather()
    }
    
    private func requestLocationAndFetchWeather() {
        view?.showLoading()
        
        locationService.requestLocation { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinate):
                    self.fetchWeatherData(lat: coordinate.latitude, lon: coordinate.longitude)
                case .failure:
                    // В случае ошибки используем координаты Москвы
                    self.fetchWeatherData(lat: 55.7558, lon: 37.6173)
                }
            }
        }
    }
    
    private func fetchWeatherData(lat: Double, lon: Double) {
        weatherService.fetchCurrentWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.hideLoading()
                
                switch result {
                case .success(let weatherData):
                    self.view?.displayWeather(weatherData)
                case .failure(let error):
                    self.view?.displayError(error.localizedDescription)
                }
            }
        }
    }
}

