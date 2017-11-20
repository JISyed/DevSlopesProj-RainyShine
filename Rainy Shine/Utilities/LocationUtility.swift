//
//  LocationUtility.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation
import CoreLocation


class LocationUtility
{
    static let instance = LocationUtility()
    private init() {}
    
    private var _latitude: Double!
    private var _longitude: Double!
    
    var latitude: Double
    {
        if _latitude == nil
        {
            print("WARNING: Couldn't get latitude! Returning 0")
            return 0.0
        }
        return _latitude
    }
    
    var longitude: Double
    {
        if _longitude == nil
        {
            print("WARNING: Couldn't get longitude! Returning 0")
            return 0.0
        }
        return _longitude
    }
    
    func setLatitude(_ newValue: Double!)
    {
        _latitude = newValue
    }
    
    func setLongitude(_ newValue: Double!)
    {
        _longitude = newValue
    }
    
}
