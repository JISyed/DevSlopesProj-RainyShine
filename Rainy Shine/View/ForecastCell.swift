//
//  ForecastCell.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell 
{
    static let REUSE_ID = "ForecastCell"
    
    @IBOutlet weak var imgWeatherConditionIcon: UIImageView!
    @IBOutlet weak var lblWeatherConditionType: UILabel!
    @IBOutlet weak var lblDayOfTheWeek: UILabel!
    @IBOutlet weak var lblHighTemperature: UILabel!
    @IBOutlet weak var lblLowTemperature: UILabel!
    
    
    
    override func awakeFromNib() 
    {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) 
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    
    func setupCell(forecastData: ForecastWeatherData, scale: TemperatureScale)
    {
        self.lblWeatherConditionType.text = forecastData.weatherCondition
        self.imgWeatherConditionIcon.image = UIImage(named: forecastData.weatherCondition + " Mini")
        self.lblDayOfTheWeek.text = forecastData.date
        
        self.lblHighTemperature.text = WeatherUtility.getTemperatureString(forKelvin: forecastData.highTemperature, andScale: scale)
        self.lblLowTemperature.text = WeatherUtility.getTemperatureString(forKelvin: forecastData.lowTemperature, andScale: scale)
    }
    
    
}





