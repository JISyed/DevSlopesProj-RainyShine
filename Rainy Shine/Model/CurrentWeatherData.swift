//
//  CurrentWeatherData.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation

class CurrentWeatherData
{
    private var _cityName: String
    private var _weatherCondition: String
    private var _currentTemperature: Double
    
    
    
    init(city: String!, weatherCondition: String!, currentTemperature: Double!) 
    {
        _cityName = city
        _weatherCondition = weatherCondition
        _currentTemperature = currentTemperature
        
    }
    
    
    
    var cityName: String
    {
        return _cityName
    }
    
    
    var weatherCondition: String
    {
        return _weatherCondition
    }
    
    
    var currentTemperature: Double
    {
        return _currentTemperature
    }
    
}

