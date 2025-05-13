//
//  WeatherView.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import UIKit

final class WeatherView: UIView {
    // MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let currentWeatherView: CurrentWeatherView = {
        let view = CurrentWeatherView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hourlyForecastView: HourlyForecastView = {
        let view = HourlyForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dailyForecastView: DailyForecastView = {
        let view = DailyForecastView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(currentWeatherView)
        contentView.addSubview(hourlyForecastView)
        contentView.addSubview(dailyForecastView)
        addSubview(loadingIndicator)
        addSubview(errorView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),

            currentWeatherView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            currentWeatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentWeatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            hourlyForecastView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: 24),
            hourlyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hourlyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor, constant: 24),
            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
                
    // MARK: - Public Methods
    func displayWeather(_ weather: WeatherData) {
        currentWeatherView.configure(with: weather)
        hourlyForecastView.configure(with: weather)
        dailyForecastView.configure(with: weather)
        
        scrollView.isHidden = false
        errorView.isHidden = true
    }
    
    func displayError(_ message: String) {
        errorView.configure(with: message)
        scrollView.isHidden = true
        errorView.isHidden = false
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        errorView.isHidden = true
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func setRetryAction(_ action: @escaping () -> Void) {
        errorView.retryAction = action
    }
}
