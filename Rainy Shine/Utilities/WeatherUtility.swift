//
//  WeatherUtility.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// "http://api.openweathermap.org/data/2.5/weather?lat=LAT&lon=LON&appid=KEY"
// "http://api.openweathermap.org/data/2.5/forecast?lat=LAT&lon=LON&appid=KEY"

enum WeatherUtility
{
    static let API_KEY = "7c0e7e4eaaab94014a3131c0838ca32a"
    static let BASE_URL = "http://api.openweathermap.org/data/2.5/"
    
    static func getCurrentWeatherUrl(forLatitude lat: Double, andLongitude lon: Double) -> String
    {
        return "\(BASE_URL)weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
    }
    
    static func getForecastWeatherUrl(forLatitude lat: Double, andLongitude lon: Double) -> String
    {
        return "\(BASE_URL)forecast?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
    }
    
    
    static func kelvinToFahrenheit(_ kelvinTemperature: Double) -> Double
    {
        return ((9.0/5.0) * kelvinTemperature) - 459.67
    }
    
    static func kelvinToCelsius(_ kelvinTemperature: Double) -> Double
    {
        return kelvinTemperature - 273.15
    }
    
    static func convertKelvin(temperature kelvinTemperature: Double, to scale: TemperatureScale) -> Double
    {
        var convertedTemperatue = 0.0
        
        switch scale 
        {
        case .celsius:
            convertedTemperatue = kelvinToCelsius(kelvinTemperature)
            break
        case .fahrenheit:
            convertedTemperatue = kelvinToFahrenheit(kelvinTemperature)
            break
        }
        
        return convertedTemperatue
    }
    
    
    static func getTemperatureString(forKelvin temperature: Double, andScale scale: TemperatureScale) -> String 
    {
        let tempConverted = WeatherUtility.convertKelvin(temperature: temperature, to: scale)
        return String(format: "%.1f", tempConverted) + "°\(scale.rawValue)"
    }
    
    
    static func downloadCurrentWeather(onComplete: @escaping (_ weatherData: CurrentWeatherData?) -> Void)
    {
        let currentWeatherURL = URL(string: WeatherUtility.getCurrentWeatherUrl(forLatitude: LocationUtility.instance.latitude, andLongitude: LocationUtility.instance.longitude))!
        Alamofire.request(currentWeatherURL).responseJSON { (response) in
            if response.result.error == nil
            {
                guard let data = response.data else { onComplete(nil); return } 
                let json = JSON(data: data)
                
                let city = json["name"].stringValue.capitalized
                
                let weatherDict = json["weather"].array!.first!
                let weatherCondition = weatherDict["main"].stringValue.capitalized
                
                let mainDict = json["main"]
                let temperature = mainDict["temp"].doubleValue
                
                let weatherData = CurrentWeatherData(city: city, weatherCondition: weatherCondition, currentTemperature: temperature)
                
                onComplete(weatherData)
            }
            else // There was an error
            {
                debugPrint(response.result.error!)
                onComplete(nil)
            }
        }
    }
    
    
    static func downloadForcastWeather(onComplete: @escaping (_ forecasts: [ForecastWeatherData]?) -> Void)
    {
        let forecastWeatherURL = URL(string: WeatherUtility.getForecastWeatherUrl(forLatitude: LocationUtility.instance.latitude, andLongitude: LocationUtility.instance.longitude))!
        Alamofire.request(forecastWeatherURL).responseJSON { (response) in
            if response.result.error == nil
            {
                guard let data = response.data else { onComplete(nil); return } 
                let json = JSON(data: data)
                
                let forecastDictListCount = json["cnt"].intValue
                if forecastDictListCount > 35
                {
                    let forecastDictList = json["list"].array!
                    
                    var finalForecastList = [ForecastWeatherData]()
                    
                    for i in 0...4 
                    {
                        let forecastDict = forecastDictList[ i*8 + 3 ]   // The +3 is just to knudge the forecasts further away from the current time
                        let mainDict = forecastDict["main"]
                        let weatherDict = forecastDict["weather"].array!.first!
                        
                        let minTemperature = mainDict["temp_min"].doubleValue
                        let maxTemperature = mainDict["temp_max"].doubleValue
                        let weatherCondition = weatherDict["main"].stringValue.capitalized
                        
                        let utcDateValue = forecastDict["dt"].doubleValue
                        let convertedDate = Date(timeIntervalSince1970: utcDateValue)
                        let dayOfTheWeek = convertedDate.dayOfTheWeek()
                        
                        let forecast = ForecastWeatherData(date: dayOfTheWeek, weatherCondition: weatherCondition, highTemperature: maxTemperature, lowTemperature: minTemperature)
                        
                        finalForecastList.append(forecast)
                    }
                    
                    onComplete(finalForecastList)
                }
                else
                {
                    // Fail
                    print("Forecast Error: The number of forecasts downloaded is under 35")
                    onComplete(nil)
                }
            }
            else // There was an error
            {
                debugPrint(response.result.error!)
                onComplete(nil)
            }
        }
    }
    
    
}




