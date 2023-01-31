//
//  WeatherManager.swift
//  Clima
//
//  Created by qihuiyu on 31/01/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    func fetchWeather(cityName: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?&q=\(cityName)&appid=195a8cbd07dbc6b55b6203baaacc33c3&units=metric"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handle(data:response:err:))
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, err: Error?) {
        if err != nil {
            print(err!)
            return
        }
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
    
}
