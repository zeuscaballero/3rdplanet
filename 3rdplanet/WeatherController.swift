//
//  WeatherController.swift
//  3rdplanet
//
//  Created by zeus on 2/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation

class WeatherController {
    
    static let baseURL = URL(string: "http://api.openweathermap.org/data/2.5/weather")
    static let cityParamKey = "q"
    static let apiParamKey = "appid"
    static let apiKey = "4720e516224a148f5684e4b11bc582bd"
    
    static func fetchWeather(withSearchTerm searchTerm: String, completion: @escaping (Weather?) -> Void) {
        guard let url = baseURL else { return }
        
        let urlParameters = [cityParamKey: searchTerm, apiParamKey: apiKey]
        
        NetworkController.performRequest(for: url, httpMethod: .get, urlParameters: urlParameters) { (data, error) in
            if let error = error {
                print("Unable to perform request for URL: \(url.absoluteString)\nError: \(error.localizedDescription)")
            }
            guard let data = data,
            let jsonDictionary = (try? JSONSerialization.jsonObject(with: data)) as? [String:AnyObject],
                let weather = Weather(dictionary: jsonDictionary) else {
                    completion(nil)
                    return
            }
            completion(weather)
        }
    }
}
