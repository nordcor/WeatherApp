//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import UIKit

final class CurrentWeatherView: UIView {
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 64, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailsStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            return stackView
        }()
        
    private var mainStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        setupMainStackView()
    }
    
    private func setupMainStackView() {
        mainStackView = UIStackView(arrangedSubviews: [
            cityLabel,
            temperatureLabel,
            conditionImageView,
            conditionLabel,
            detailsStackView
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.setCustomSpacing(16, after: conditionLabel)
        addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with weather: WeatherData) {
        cityLabel.text = "\(weather.location.name), \(weather.location.country)"
        temperatureLabel.text = "\(Int(weather.current.temp_c))°"
        conditionLabel.text = weather.current.condition.text
        
        if let iconUrl = URL(string: "https:\(weather.current.condition.icon)") {
            loadImage(from: iconUrl)
        }
        
        setupDetails(with: weather.current)
    }
    
    private func setupDetails(with current: CurrentWeather) {
        detailsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let windView = createDetailView(title: "Ветер", value: "\(current.wind_kph) km/h", icon: "wind")
        let humidityView = createDetailView(title: "Влажность", value: "\(current.humidity)%", icon: "humidity")
        let precipitationView = createDetailView(title: "Осадки", value: "\(current.precip_mm) mm", icon: "drop")
        let pressureView = createDetailView(title: "Давление", value: "\(current.pressure_mb) mb", icon: "barometer")
        
        detailsStackView.addArrangedSubview(windView)
        detailsStackView.addArrangedSubview(humidityView)
        detailsStackView.addArrangedSubview(precipitationView)
        detailsStackView.addArrangedSubview(pressureView)
    }
    
    private func createDetailView(title: String, value: String, icon: String) -> UIView {
        let view = UIView()
        
        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, valueLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }
    
    //TODO:
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.conditionImageView.image = image
                }
            }
        }.resume()
    }
}
