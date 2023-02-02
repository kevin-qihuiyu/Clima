//
//  WeatherManager.swift
//  Clima
//
//  Created by qihuiyu on 31/01/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?&q=\(cityName)&appid=195a8cbd07dbc6b55b6203baaacc33c3&units=metric"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data, response, err) in
                if err != nil {
                    self.delegate?.didFailWithError(error: err!)
                    return
                }
                if let safeData = data {
                    if let weatherModel = parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weatherModel)
                    }
                    return
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData : Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }        
    }
    
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
