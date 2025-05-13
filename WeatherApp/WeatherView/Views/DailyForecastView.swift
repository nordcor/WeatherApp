//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import UIKit

final class DailyForecastView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Погода на 3 дня"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.cellID)
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    private var stackView: UIStackView!
    
    private var dailyData: [ForecastDay] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        
        stackView = UIStackView(arrangedSubviews: [titleLabel, tableView])
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
        ])
    }
    
    func configure(with weather: WeatherData) {
        guard let forecast = weather.forecast else { return }
        dailyData = forecast.forecastday
        tableView.reloadData()
        
        let height = self.tableView.contentSize.height
        self.tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.layoutIfNeeded()
    }
}

extension DailyForecastView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.cellID, for: indexPath) as! DailyForecastCell
        cell.configure(with: dailyData[indexPath.row])
        return cell
    }
}

// MARK: DailyForecastCell

private final class DailyForecastCell: UITableViewCell {
    static let cellID = "DailyForecastCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let highTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let lowTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let tempStackView = UIStackView(arrangedSubviews: [highTempLabel, lowTempLabel])
        tempStackView.axis = .horizontal
        tempStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [dayLabel, iconImageView, tempStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            dayLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        ])
    }
    
    func configure(with dailyData: ForecastDay) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dailyData.date) {
            dateFormatter.dateFormat = "EEEE"
            dayLabel.text = dateFormatter.string(from: date)
        } else {
            dayLabel.text = dailyData.date
        }
        
        highTempLabel.text = "\(Int(dailyData.day.maxtemp_c))°"
        lowTempLabel.text = "\(Int(dailyData.day.mintemp_c))°"
        
        // TODO
        if let iconUrl = URL(string: "https:\(dailyData.day.condition.icon)") {
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
