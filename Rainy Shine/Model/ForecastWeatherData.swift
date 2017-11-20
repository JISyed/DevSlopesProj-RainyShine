//
//  ForecastWeatherData.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation

class ForecastWeatherData
{
    private var _date: String
    private var _weatherCondition: String
    private var _highTemperature: Double
    private var _lowTemperature: Double
    
    
    init(date: String!, weatherCondition: String!, highTemperature: Double!, lowTemperature: Double!) 
    {
        _date = date ?? "ERROR"
        _weatherCondition = weatherCondition ?? "ERROR"
        _highTemperature = highTemperature ?? 0.0
        _lowTemperature = lowTemperature ?? 0.0
    }
    
    
    var date: String
    {
        return _date
    }
    
    var weatherCondition: String
    {
        return _weatherCondition
    }
    
    var highTemperature: Double
    {
        return _highTemperature
    }
    
    var lowTemperature: Double
    {
        return _lowTemperature
    }
    
    
}
