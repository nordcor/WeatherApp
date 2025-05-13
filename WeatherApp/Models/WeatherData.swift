//
//  WeatherData.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//
import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast?
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}

struct CurrentWeather: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let precip_mm: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let uv: Double
    let gust_kph: Double
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
    let code: Int
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let date_epoch: Int
    let day: Day
    let astro: Astro
    let hour: [HourlyForecast]
}

struct Day: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let maxwind_kph: Double
    let totalprecip_mm: Double
    let totalsnow_cm: Double
    let avgvis_km: Double
    let avghumidity: Int
    let daily_will_it_rain: Int
    let daily_chance_of_rain: Int
    let daily_will_it_snow: Int
    let daily_chance_of_snow: Int
    let condition: WeatherCondition
    let uv: Double
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: Int
    let is_moon_up: Int
    let is_sun_up: Int
}

struct HourlyForecast: Codable {
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let precip_mm: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let windchill_c: Double
    let windchill_f: Double
    let heatindex_c: Double
    let heatindex_f: Double
    let dewpoint_c: Double
    let dewpoint_f: Double
    let will_it_rain: Int
    let chance_of_rain: Int
    let will_it_snow: Int
    let chance_of_snow: Int
    let vis_km: Double
    let gust_kph: Double
    let uv: Double
}
