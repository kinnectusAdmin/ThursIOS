//
//  ConvoDateSection.swift
//  Thurst
//
//  Created by Blake Rogers on 2/1/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import Foundation
struct  ConvoDateSection{
    var date = Date()
    var dateDescription : String{
        return MyCalendar.generalTimeSinceEvent(onDate: date)
    }
    var sectionTitle = ""
    var convos: [String] = []
}
