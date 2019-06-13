//
//  LoadingViewController.swift
//  Weather
//
//  Created by Brayden Harris on 6/12/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit
import CoreLocation

class LoadingViewController: UIViewController {

    // MARK: - Properties
    var locationFetched = false
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation? {
        didSet {
            guard let location = currentLocation else { return }
            
            // Fetch My Location Data
            WeatherDataController.fetchWeatherData(byLocation: location) { (weatherData) in
                guard let weatherData = weatherData else { return }
                
                self.myLocationData = weatherData
                
                WeatherDataController.fetchIconFor(weatherData: weatherData, completion: { (icon) in
                    guard let icon = icon else { return }
                    
                    self.myLocationIcon = icon
                })
            }
            
            // Fetch London Data
            WeatherDataController.fetchWeatherData(byCityID: "2643743") { (weatherData) in
                guard let weatherData = weatherData else { return }
                
                self.londonData = weatherData
                
                WeatherDataController.fetchIconFor(weatherData: weatherData, completion: { (icon) in
                    guard let icon = icon else { return }
                    
                    self.londonIcon = icon
                })
            }
            
            // Fetch Tokyo Data
            WeatherDataController.fetchWeatherData(byCityID: "1850147") { (weatherData) in
                guard let weatherData = weatherData else { return }
                
                self.tokyoData = weatherData
                
                WeatherDataController.fetchIconFor(weatherData: weatherData, completion: { (icon) in
                    guard let icon = icon else { return }
                    
                    self.tokyoIcon = icon
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toWeatherData", sender: nil)
                    }
                })
            }
        }
    }
    var myLocationData: WeatherData?
    var myLocationIcon: UIImage?
    var londonData: WeatherData?
    var londonIcon: UIImage?
    var tokyoData: WeatherData?
    var tokyoIcon: UIImage?

    @IBOutlet weak var checkWeatherView: UIView!
    @IBOutlet weak var checkWeatherLabel: UILabel!
    @IBOutlet weak var loadingTitle: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingTitle.adjustsFontSizeToFitWidth = true
        checkWeatherLabel.adjustsFontSizeToFitWidth = true
        checkWeatherView.layer.cornerRadius = 20
        
        getLocation()
    }
    
    @IBAction func checkWeatherButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.checkWeatherView.alpha = 0
            }
        }
        
        getLocation()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherData" {
            guard let destinationVC = segue.destination as? HomeViewController,
                let myLocationData = myLocationData, let myLocationIcon = myLocationIcon, let londonData = londonData, let londonIcon = londonIcon, let tokyoData = tokyoData, let tokyoIcon = tokyoIcon else { return }
            
            destinationVC.myLocationData = myLocationData
            destinationVC.myLocationIcon = myLocationIcon
            destinationVC.londonData = londonData
            destinationVC.londonIcon = londonIcon
            destinationVC.tokyoData = tokyoData
            destinationVC.tokyoIcon = tokyoIcon
        }
    }
}
// MARK: - LocationManagerDelegate
extension LoadingViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
            
        @unknown default:
            fatalError("CLAuthorizationStatus has additional values")
        }
        
        DispatchQueue.main.async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            if locationFetched == false {
                self.currentLocation = currentLocation
                locationFetched = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
