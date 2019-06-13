//
//  CityDetailViewController.swift
//  Weather
//
//  Created by Brayden Harris on 6/11/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {

    // MARK: - Properties
    var city: String?{
        didSet {
            loadViewIfNeeded()
            cityLabel.text = city
        }
    }
    var weatherData: WeatherData? {
        didSet {
            loadViewIfNeeded()
            guard let weatherData = weatherData else { return }
            temperatureLabel.text = "\(Int(weatherData.temperature.temperature * (9/5) - 459.67))ºF"
            windLabel.text?.append(" \(Int(weatherData.wind.wind * 2.237)) mph")
            cloudsLabel.text?.append(" \(weatherData.clouds.clouds)%")
        }
    }
    var weatherIcon: UIImage? {
        didSet {
            loadViewIfNeeded()
            weatherIconImageView.image = weatherIcon
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        cityLabel.font = UIFont(name: "Hiragino Sans", size: view.frame.width / 6)
        cityLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
