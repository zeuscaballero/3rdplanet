//
//  WeatherViewController.swift
//  3rdplanet
//
//  Created by zeus on 2/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var conditionsLabel: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        searchBar.resignFirstResponder()
        
        WeatherController.fetchWeather(withSearchTerm: searchTerm) { (weather) in
            DispatchQueue.main.async {
                guard let weather = weather else { return }
                self.cityLabel.text = weather.city
                self.conditionsLabel.text = "Conditions: \(weather.conditions.joined(separator: ","))"
                self.temperatureLabel.text = "\(weather.temperature)℉"
                self.highLabel.text = "Hi \(weather.tempHigh)℉"
                self.lowLabel.text = "Low \(weather.tempLow)℉"
                self.humidityLabel.text = "Humidity: \(weather.humidity)%"
            }
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
