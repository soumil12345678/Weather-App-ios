//
//  ViewController.swift
//  Weather App
//
//  Created by Soumil on 23/04/19.
//  Copyright © 2019 LPTP233. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var weatherDesLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var cloudStatusLbl: UILabel!
    let url = "https://api.openweathermap.org/data/2.5/weather"
    let apikey = "6f22021d0d0798d2a60a818090ffe5ad"
    let locationManager = CLLocationManager()
    var longitude:Double = 0
    var latitude:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLabel.adjustsFontSizeToFitWidth = true
        settingUpLocationManager()
    }

    func settingUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func fetchingWeatherDataRequest(){
        let params:[String: String] = ["lat": String(latitude), "lon": String(longitude), "appid": apikey]
        Alamofire.request(url, method: .get, parameters: params).responseData {
            response in
            if let data = response.data ,response.result.isSuccess {
                self.parsingJson(data: data)
            }else {
                print("Failure: \(response.result.error!)")
            }
        }
    }

    func parsingJson(data: Data) {
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            UpdateUIFields(weatherData:weatherData)
            print(weatherData)
        } catch let err {
            print(err)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
            locationManager.startUpdatingLocation()
            longitude = location.coordinate.longitude
            latitude = location.coordinate.latitude
            locationManager.delegate = nil
            fetchingWeatherDataRequest()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        let errorAlert = UIAlertController(title: "Location Not Found", message: "Unable to find your location", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(errorAlert, animated: true, completion: nil)
    }
    
    func UpdateUIFields(weatherData: WeatherData) {
        weatherDesLbl.isHidden = false
        pressureLbl.isHidden = false
        currentTempLbl.isHidden = false
        humidityLbl.isHidden = false
        windSpeedLbl.isHidden = false
        cloudStatusLbl.isHidden = false
        cityNameLabel.text = "\(weatherData.name)"
        weatherDesLbl.text = "Weather: \(weatherData.base.description)"
        pressureLbl.text = "Pressure: \(weatherData.main.pressure)inHg"
        currentTempLbl.text = "Temp: \(Float(weatherData.main.temp - 273))°C"
        humidityLbl.text = "Humidity: \(weatherData.main.humidity)%"
        windSpeedLbl.text = "Wind Speed: \(weatherData.wind.speed)km/h"
        cloudStatusLbl.text = "Chance of rain: \(weatherData.clouds.all)%"
        cloudStatusLbl.adjustsFontSizeToFitWidth = true
    }
}

