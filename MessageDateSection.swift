//
//  MessageDateSection.swift
//  Thurst
//
//  Created by Blake Rogers on 2/5/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import Foundation
struct  MessageDateSection{
    var date = Date()
    var dateDescription : String{
        return MyCalendar.generalTimeSinceEvent(onDate: date)
    }
    var sectionTitle = ""
    var messages: [String] = []
}
