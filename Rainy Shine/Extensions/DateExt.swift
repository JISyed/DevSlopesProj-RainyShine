//
//  DateExt.swift
//  Rainy Shine
//
//  Created by Jibran Syed on 10/31/17.
//  Copyright © 2017 Jishenaz. All rights reserved.
//

import Foundation

extension Date
{
    func dayOfTheWeek() -> String 
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
