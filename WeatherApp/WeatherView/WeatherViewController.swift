//
//  ViewController.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    // MARK: - Properties
    
    private let weatherView = WeatherView()
    private var presenter: WeatherPresenterProtocol!
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupNavigationBar()
        setupRetryAction()
        presenter.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupPresenter() {
        let weatherService = WeatherService()
        let locationService = LocationService()
        presenter = WeatherPresenter(
            view: self,
            weatherService: weatherService,
            locationService: locationService
        )
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Погода"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshButtonTapped)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func setupRetryAction() {
        weatherView.setRetryAction { [weak self] in
            self?.presenter.retryFetchWeather()
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped() {
        presenter.retryFetchWeather()
    }
}

// MARK: - WeatherViewProtocol

extension WeatherViewController: WeatherViewProtocol {
    func displayWeather(_ weather: WeatherData) {
        self.navigationItem.title = weather.location.name
        self.weatherView.displayWeather(weather)
    }
    
    func displayError(_ message: String) {
        self.weatherView.displayError(message)
    }
    
    func showLoading() {
        self.weatherView.showLoading()
    }
    
    func hideLoading() {
        self.weatherView.hideLoading()
    }
}


