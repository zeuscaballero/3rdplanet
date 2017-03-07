//
//  Weather.swift
//  3rdplanet
//
//  Created by zeus on 2/7/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation

struct Weather {
    
    static private let kCity = "name"
    static private let kWeatherArray = "weather"
    static private let kMain = "main"
    static private let kClouds = "clouds"
    static private let kTemp = "temp"
    static private let kHumidity = "humidity"
    static private let kDescription = "description"
    static private let kAll = "all"
    static private let kHigh = "temp_max"
    static private let kLow = "temp_min"

    
    let city : String
    let conditions: [String]
    let temperature: Int
    let humidity: Int
    let clouds: Int
    let tempHigh: Int
    let tempLow: Int
    
    
    
    init?(dictionary: [String:AnyObject]) {
        guard let city = dictionary[Weather.kCity] as? String,
            let weatherArray = dictionary[Weather.kWeatherArray] as? [[String:AnyObject]],
            let mainDictionary = dictionary[Weather.kMain] as? [String:AnyObject],
            let cloudsDictionary = dictionary[Weather.kClouds] as? [String:AnyObject],
            let temperatureInKelvin = mainDictionary[Weather.kTemp] as? Double,
            let clouds = cloudsDictionary[Weather.kAll] as? Int,
            let humidity = mainDictionary[Weather.kHumidity] as? Int,
            let tempHigh = mainDictionary[Weather.kHigh] as? Double,
           let tempLow = mainDictionary[Weather.kLow] as? Double
        else { return nil }
        
        let conditions = weatherArray.flatMap { $0[Weather.kDescription] }
        
        self.temperature = Int(temperatureInKelvin - 270)*9/5 + 32
        self.city = city
        self.conditions = conditions as! [String]
        self.humidity = humidity
        self.clouds = clouds
        self.tempHigh = Int(tempHigh * (9/5) - 459.67) + 10
        self.tempLow = Int(tempLow * (9/5) - 459.67) - 5
    }
}

