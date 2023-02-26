//
//  WeatherData.swift
//  Clima
//
//  Created by Thitiphong Wancham on 24/2/2566 BE.
//  Copyright © 2566 BE App Brewery. All rights reserved.
//

import Foundation

// All properties' name must match with the one that come from JSON data

struct WeatherData: Codable {  // A type that can decode itself from an external representation.
    let name: String
    // Because "main" is also hold another object, so we have to create another struct for it
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
