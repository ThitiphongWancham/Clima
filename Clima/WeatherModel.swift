//
//  WeatherModel.swift
//  Clima
//
//  Created by Thitiphong Wancham on 24/2/2566 BE.
//  Copyright © 2566 BE App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...299:
            return "cloud.bolt.rain.fill"
        case 300...399:
            return "cloud.drizzle.fill"
        case 500...599:
            return "cloud.rain.fill"
        case 600...699:
            return "snowflake"
        case 700...771:
            return "cloud.fog.fill"
        case 781:
            return "tornado"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.fill"
        default:
            return "xmark.icloud.fill"
        }
    }
}


