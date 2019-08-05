//
//  Connection.swift
//  Thurst
//
//  Created by Blake Rogers on 2/9/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import Foundation

class Connection: NSObject{
    var user_id: String?
    var name: String?
    var user_image: String?
    var timestamp: NSNumber?
    var connectionDate: Date{
        guard let dateInterval:TimeInterval = timestamp?.doubleValue else { return Date()}
        let date = Date(timeIntervalSince1970: dateInterval)
        return date
    }
    var connectionDescription: String{
        return MyCalendar().stringFromDate(date: connectionDate)
    }
}
