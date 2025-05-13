//
//  LocationService.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void)
    func requestAuthorization()
}

class LocationService: NSObject, LocationServiceProtocol {
    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    private let moscowCoordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        self.completion = completion
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(.success(moscowCoordinate)) // Используем Москву при отказе
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            completion(.failure(LocationError.unknown))
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            completion?(.success(location))
            completion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // При ошибке геолокации используем Москву
        completion?(.success(moscowCoordinate))
        completion = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            completion?(.success(moscowCoordinate)) // Используем Москву при отказе
            completion = nil
        default:
            break
        }
    }
}

enum LocationError: Error {
    case permissionDenied
    case unknown
}
