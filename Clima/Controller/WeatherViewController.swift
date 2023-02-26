//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

//MARK: - ViewController
class WeatherViewController: UIViewController {
    
    
    //MARK: - PROPERTIES
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var keys: NSDictionary?
    
    
    //MARK: - IBOUTLET
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //MARK: - IBACTION
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // API key
        manageAPIKey()
        
        // TextField
        searchTextField.delegate = self
        
        // WeatherManager
        weatherManager.delegate = self
        
        // LocationManager
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    //MARK: - Manage API
    func manageAPIKey() {
        // Get API key from Keys.plist
        if let url = Bundle.main.url(forResource: "Keys", withExtension: "plist") {
            do {
                keys = try NSDictionary(contentsOf: url, error: ())
            } catch {
                print("You have to create Keys.plist with your API key.")
            }
        }
        // Use the value to update the request URL
        if let keys = keys {
            let apiKey = keys["APIKey"] as? String
            weatherManager.updateURLWithAPIKey(apiKey)
        }
    }
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            // Perform networking
            weatherManager.fetchWeather(city: city)
        }
        searchTextField.text = ""
    }
    
    // Useful for doing some validation on what the user typed
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Stop finding location after getting one
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(lat: latitude, lon: longitude)
        }
    }
}
