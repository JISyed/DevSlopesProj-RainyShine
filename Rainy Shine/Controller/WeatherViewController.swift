//
//  WeatherViewController.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController 
{
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCurrentTemperature: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgCurrentWeather: UIImageView!
    @IBOutlet weak var lblCurrentWeatherType: UILabel!
    @IBOutlet weak var tableForecasts: UITableView!
    @IBOutlet weak var btnTempScaleSwitcher: UIButton!
    
    
    var currentWeather: CurrentWeatherData?
    var forecasts = [ForecastWeatherData]()
    var temperatureScale: TemperatureScale = .fahrenheit
    
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.lblDate.text = ""
        self.lblLocation.text = ""
        self.lblCurrentTemperature.text = ""
        self.lblCurrentWeatherType.text = ""
        self.imgCurrentWeather.image = nil
        
        self.btnTempScaleSwitcher.setTitle("°\(self.temperatureScale.rawValue)", for: .normal)
        
        
        self.tableForecasts.delegate = self
        self.tableForecasts.dataSource = self
        
        
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters //kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringSignificantLocationChanges()
        
        
        
        
    }
    
    
    // Runs before viewDidLoad()
    override func viewDidAppear(_ animated: Bool) 
    {
        super.viewDidAppear(animated)
        
        self.getLocation()
        self.getWeather()
    }
    
    
    
    func updateCurrentWeatherUI()
    {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())    // Create a current data
        self.lblDate.text = "Today, \(currentDate)"
        
        self.updateTemperatureScaleUI()
        
        self.lblCurrentWeatherType.text = self.currentWeather!.weatherCondition
        self.lblLocation.text = self.currentWeather!.cityName
        self.imgCurrentWeather.image = UIImage(named: self.currentWeather!.weatherCondition)
    }
    
    
    
    
    func updateTemperatureScaleUI()
    {
        guard let currWeather = self.currentWeather else {return}
        
        self.lblCurrentTemperature.text = WeatherUtility.getTemperatureString(forKelvin: currWeather.currentTemperature, andScale: self.temperatureScale)
        
        switch self.temperatureScale 
        {
        case .celsius:
            self.btnTempScaleSwitcher.setTitle("°\(TemperatureScale.fahrenheit.rawValue)", for: .normal)
            break
        case .fahrenheit:
            self.btnTempScaleSwitcher.setTitle("°\(TemperatureScale.celsius.rawValue)", for: .normal)
            break
        }
        
        self.tableForecasts.reloadData()
    }
    
    
    
    func getWeather()
    {
        WeatherUtility.downloadCurrentWeather { (weatherDataOpt) in
            if let weatherData = weatherDataOpt
            {
                self.currentWeather = weatherData
            }
            else
            {
                self.currentWeather = CurrentWeatherData(city: "ERROR", weatherCondition: "Rain", currentTemperature: 0.0)
            }
            self.updateCurrentWeatherUI()
        }
        
        
        WeatherUtility.downloadForcastWeather { (forecastsOpt) in
            if let newForecasts = forecastsOpt
            {
                self.forecasts = newForecasts
            }
            else
            {
                self.forecasts = [ForecastWeatherData]()
            }
            self.tableForecasts.reloadData()
        }
    }
    
    
    
    @IBAction func onTempScaleSwitcherPressed(_ sender: Any) 
    {
        switch self.temperatureScale 
        {
        case .celsius:
            self.temperatureScale = .fahrenheit
            break
        case .fahrenheit:
            self.temperatureScale = .celsius
            break
        }
        
        self.updateTemperatureScaleUI()
    }
    
    
}



// Table stuff
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int 
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return self.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.REUSE_ID, for: indexPath) as? ForecastCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(forecastData: self.forecasts[indexPath.row], scale: self.temperatureScale)
        
        return cell
    }
    
    
}


// Location stuff
extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) 
    {
        let newLocation = locations.first!
        self.updateLocationCoordinateData(newLocation: newLocation)
        self.getWeather()
    }
    
    
    
    
    // Custom stuff not part of CLLocationManagerDelegate
    // but still relevant to location
    
    func getLocation()
    {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            self.updateLocationCoordinateData(newLocation: self.locationManager.location)
        }
        else
        {
            self.locationManager.requestWhenInUseAuthorization()
            self.getLocation()  // Try again
        }
    }
    
    
    func updateLocationCoordinateData(newLocation: CLLocation?)
    {
        self.currentLocation = newLocation
        LocationUtility.instance.setLatitude(self.currentLocation.coordinate.latitude)
        LocationUtility.instance.setLongitude(self.currentLocation.coordinate.longitude)
    }
}




