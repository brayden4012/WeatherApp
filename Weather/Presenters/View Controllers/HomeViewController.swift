//
//  HomeViewController.swift
//  Weather
//
//  Created by Brayden Harris on 6/11/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    var myLocationData: WeatherData?
    var myLocationIcon: UIImage?
    var londonData: WeatherData?
    var londonIcon: UIImage?
    var tokyoData: WeatherData?
    var tokyoIcon: UIImage?
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myLocationWeatherImageView: UIImageView!
    @IBOutlet weak var myLocationTempLabel: UILabel!
    @IBOutlet weak var myLocationLabel: UILabel!
    @IBOutlet weak var londonWeatherImageView: UIImageView!
    @IBOutlet weak var londonTempLabel: UILabel!
    @IBOutlet weak var londonLabel: UILabel!
    @IBOutlet weak var tokyoWeatherImageView: UIImageView!
    @IBOutlet weak var tokyoTempLabel: UILabel!
    @IBOutlet weak var tokyoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont(name: "Hiragino Sans", size: view.frame.width / 6)
        
        myLocationLabel.font = UIFont.systemFont(ofSize: view.frame.width / 13, weight: .light)
        
        londonLabel.font = UIFont.systemFont(ofSize: view.frame.width / 13, weight: .light)
        
        tokyoLabel.font = UIFont.systemFont(ofSize: view.frame.width / 13, weight: .light)
        
        updateViews()
    }
    
    func updateViews() {
        guard let myLocationData = myLocationData,
            let myLocationIcon = myLocationIcon,
            let londonData = londonData,
            let londonIcon = londonIcon,
            let tokyoData = tokyoData,
            let tokyoIcon = tokyoIcon else { return }
        
        self.myLocationLabel.text = myLocationData.city
        self.myLocationWeatherImageView.image = myLocationIcon
        self.myLocationTempLabel.text = "\(Int(myLocationData.temperature.temperature * (9/5) - 459.67))ºF"
        self.londonWeatherImageView.image = londonIcon
        self.londonTempLabel.text = "\(Int(londonData.temperature.temperature * (9/5) - 459.67))ºF"
        self.tokyoWeatherImageView.image = tokyoIcon
        self.tokyoTempLabel.text = "\(Int(tokyoData.temperature.temperature * (9/5) - 459.67))ºF"
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? CityDetailViewController else { return }
        if segue.identifier == "toMyLocationDetails" {
            destinationVC.city = myLocationData?.city
            destinationVC.weatherData = myLocationData
            destinationVC.weatherIcon = myLocationIcon
        } else if segue.identifier == "toLondonDetails" {
            destinationVC.city = "London, England"
            destinationVC.weatherData = londonData
            destinationVC.weatherIcon = londonIcon
        } else {
            destinationVC.city = "Tokyo, Japan"
            destinationVC.weatherData = tokyoData
            destinationVC.weatherIcon = tokyoIcon
        }
    }
}
