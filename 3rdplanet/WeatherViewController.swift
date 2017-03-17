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
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "geography (1)")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(WeatherViewController.dismissKeyboard)))
        
        searchBar.barTintColor = .white
        
//        let weatherView = self.storyboard?.instantiateViewController(withIdentifier: "weatherView") as UIViewController!
//        self.addChildViewController(weatherView!)
//        self.scrollView.addSubview((weatherView?.view)!)
//        weatherView?.didMove(toParentViewController: self)
//        weatherView?.view.frame = scrollView.bounds
        
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }


    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var conditionsLabel: UILabel!
    
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text?.lowercased() else { return }
        searchBar.resignFirstResponder()
        
        
        
        WeatherController.fetchWeather(withSearchTerm: searchTerm) { (weather) in
            DispatchQueue.main.async {
                guard let weather = weather else { return }
                ImageController.image(forURL: weather.imageURL, completion: { (image) in
                self.cityLabel.text = weather.city
                self.weatherImage.image = image
                self.conditionsLabel.text = "\(weather.conditions.joined(separator: ","))"
                self.temperatureLabel.text = "\(weather.temperature)℉"
                self.highLabel.text = "Hi \(weather.tempHigh)℉"
                self.lowLabel.text = "Low \(weather.tempLow)℉"
                self.humidityLabel.text = "Humidity: \(weather.humidity)%"
                })
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
