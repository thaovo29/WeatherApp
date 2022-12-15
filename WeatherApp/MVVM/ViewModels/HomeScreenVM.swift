//
//  ViewModel.swift
//  WeatherApp
//
//  Created by MacOS on 12/12/2022.
//

import Foundation
import CoreLocation
import UIKit

class HomeScreenVM {
    var models = [DailyWeatherEntry]()
    var currentLocation: CLLocation?
    var current : CurrentWeather?
    var hourlyModels = [HourlyWeatherEntry]()
    var callBack : (() -> Void)?
    
    func requestWeatherForLocation() -> (){
        guard let currentLocation = currentLocation else {return}
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        print("\(long) | \(lat)")
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            // validation
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error \(error)")
            }
            
            guard let result = json else {return}
            let entries = result.daily.data
            self.models.append(contentsOf: entries)
            let currentWeather = result.currently
            self.current = currentWeather
            
            self.hourlyModels = result.hourly.data
            self.callBack?()
        }).resume()
    }
}
