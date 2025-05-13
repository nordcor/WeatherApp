//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import UIKit

final class HourlyForecastView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Почасовая погода"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 100)
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.cellID)
        return collectionView
    }()
    
    private var stackView: UIStackView!
    
    private var hourlyData: [HourlyForecast] = []
    
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

        collectionView.dataSource = self

        stackView = UIStackView(arrangedSubviews: [titleLabel, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func configure(with weather: WeatherData) {
        guard let forecast = weather.forecast, !forecast.forecastday.isEmpty else { return }
        
        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        
        // Получаем текущие часы сегодня и все часы на завтра
        let todayHours = forecast.forecastday[0].hour
        let tomorrowHours = forecast.forecastday.count > 1 ? forecast.forecastday[1].hour : []
        
        let remainingTodayHours = todayHours.filter { hour in
            guard let hourDate = hour.time.toDate(format: "yyyy-MM-dd HH:mm") else { return false }
            let hourNumber = calendar.component(.hour, from: hourDate)
            return hourNumber >= currentHour
        }
        
        hourlyData = remainingTodayHours + tomorrowHours
        collectionView.reloadData()
    }
}

extension HourlyForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.cellID, for: indexPath) as! HourlyForecastCell
            cell.configure(with: hourlyData[indexPath.row])
            return cell
        }
    }

// MARK: HourlyForecastCell
private final class HourlyForecastCell: UICollectionViewCell {
    static let cellID = "HourlyForecastCell"

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with hourlyData: HourlyForecast) {
        // Получаем время "2023-04-01 14:00" -> "14:00"
        let timeComponents = hourlyData.time.components(separatedBy: " ")
        timeLabel.text = timeComponents.last?.components(separatedBy: ":").first?.appending(":00") ?? "--"
        
        tempLabel.text = "\(Int(hourlyData.temp_c))°"
        
        // TODO:
        if let iconUrl = URL(string: "https:\(hourlyData.condition.icon)") {
            URLSession.shared.dataTask(with: iconUrl) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.iconImageView.image = image
                    }
                }
            }.resume()
        }
    }
}
