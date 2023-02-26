//
//  WeatherManager.swift
//  Clima
//
//  Created by Thitiphong Wancham on 24/2/2566 BE.
//  Copyright © 2566 BE App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - PROTOCOL
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}


//MARK: - STRUCT
struct WeatherManager {
    
    
    //MARK: - PROPERTIES
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    //MARK: - Update URL with API key
    mutating func updateURLWithAPIKey(_ apiKey: String?) {
        if let apiKey = apiKey {
            weatherURL += "&appid=\(apiKey)"
        }
    }
    
    
    //MARK: - Fetch Weather
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString)
    }
    
    
    //MARK: - Perform Request
    func performRequest(_ urlString: String) {
        
        // Create a URL
        if let url = URL(string: urlString) {
            
            // Create a URLSession
            let session = URLSession(configuration: .default)
            
            // Give URLSession a task
            let task = session.dataTask(with: url) { data, _, error in
                // Error
                guard error == nil else {
                    delegate?.didFailWithError(error!)
                    return
                }
                // Data
                if let data = data {
                    // JSON -> WeatherModel(WeatherData)
                    if let weatherModel = self.parseJSON(data) {
                        delegate?.didUpdateWeather(self, weatherModel)
                    }
                }
            }
            
            // Start the task
            task.resume()  // Newly-initialized tasks begin in a suspended state, so you need to call this method to start the task.
        }
    }
    
    
    //MARK: - Parse JSON Data
    func parseJSON(_ data: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)  // WeatherData.self returns the data type (WeatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            // Store parsed data inside WeatherModel object, it will be used to update UI
            return WeatherModel(conditionID: id, cityName: name, temperature: temp)
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
