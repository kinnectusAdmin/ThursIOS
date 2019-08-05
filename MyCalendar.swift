//
//  MyCalendar.swift
//  Gymmie
//
//  Created by Blake Rogers on 8/5/16.
//  Copyright © 2016 Kinnectus. All rights reserved.
//

import Foundation

struct MyCalendar{
    static  let jan = 31
    static  var feb: Int{
        let remainder = thisYear%4
        return remainder == 0 ? 29 : 28
    }
    static  let mar = 31
    static  let apr = 30
    static  let may = 31
    static  let jun = 30
    static  let jul = 31
    static  let aug = 31
    static  let sep = 30
    static  let oct = 31
    static  let nov = 30
    static  let dec = 31
    
    static   var monthLengths: [Int]{
        return [dec,jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec]
    }
    
    static   let dayInSeconds = 1600*24
    static   var weekInSeconds: Int{
        return dayInSeconds*7
    }
    static   var monthInSeconds: Int{
        return dayInSeconds*31
    }
    static   var now = Date()
    static let calendar = Foundation.Calendar.current
    static    var monthNames: [String]{
        return calendar.monthSymbols
        
    }
    static var weekdays: [String]{
        let days = calendar.weekdaySymbols
        return ["offset"]+days
    }
    static let formattedDays = ["offset","Sun","Mon","Tues","Wed","Thurs","Fri","Sat"]
    static   var thisMonth: String{
        let monthInt = calendar.component(.month, from: now)
        
        return monthNames[max(0,monthInt-1)]
    }
    static  var monthsLeftInYear: Int{
        return 12-thisMonthInt
        
    }
    static   var thisMonthInt: Int{
        let monthInt = calendar.component(.month, from: now)
        
        return monthInt
        
    }
    static var thisWeekInt: Int{
        let weekInt = calendar.component(.weekOfMonth, from: now)
        return weekInt
    }
    static var thisYear: Int{
        return calendar.component(.year, from: now)
    }
    static   var today: String{
        let todayInt = calendar.component(.day, from: now)
        return weekdays[todayInt]
        
    }
    static   var todayInt: Int{
        let todayInt = calendar.component(.day, from: now)
        
        return todayInt
        
    }
    static var endOfMonth: Int{
        let monthInt = calendar.component(.month, from: now)-1
        return monthLengths[monthInt]
        
    }
    static   var daysLeftInMonth: Int{
        let todayInt = calendar.component(.day, from: now)
        
        return abs(todayInt-endOfMonth)
    }
    static func formatWorkoutSlot(fromTime start: Date, toTime end: Date )-> String{
        let fromTime = time(forDate: start)
        let endTime = time(forDate: end)
        
        return "\(fromTime) - \(endTime)"
    }
    static func firstWeekDay(forMonth month: Int)->Int{
        var comp = DateComponents()
        comp.day = 1
        comp.month = month
        comp.year = thisYear
        let date = calendar.date(from: comp)
        let weekDay = calendar.dateComponents([.weekday], from: date!)
        
        return weekDay.weekday!
    }
    static func weekday(forDate date: Date)->String{
        let weekDay = calendar.component(.weekday, from: date)
        let day = weekdays[weekDay]
        return day
    }
    static func formattedWeekday(forDate date: Date)->String{
        let weekDay = calendar.component(.weekday, from: date)
        let day = formattedDays[weekDay]
        return day
    }
    static func month(forDate date: Date)->String{
        let month = calendar.component(.month, from: date)
        let monthName = monthNames[month-1]
        return monthName
    }
    static func workoutTime(forDate date: Date)-> String{
        let hourComp = calendar.component(.hour, from: date)
        let hour = hourComp > 12 ? hourComp - 12 : hourComp
        let trueHour = hour == 0 ? 12 : hour
        let minComp = calendar.component(.minute, from: date)
        let min = minComp < 10 ? "0\(minComp)" : "\(minComp)"
        
        let noon = hourComp > 11 ? "pm" : "am"
        let time = "\(trueHour):\(min) \(noon)"
        return time
    }
    static func time(forDate date: Date)-> String{
        let hourComp = calendar.component(.hour, from: date)
        let hour = hourComp > 12 ? hourComp - 12 : hourComp
        let trueHour = hour == 0 ? 12 : hour
        let minComp = calendar.component(.minute, from: date)
        let min = minComp < 10 ? "0\(minComp)" : "\(minComp)"
        
        let noon = hourComp > 11 ? "pm" : "am"
        let time = "\(trueHour):\(min) \(noon)"
        return time
    }
    static func lastWeekDay(forMonth month: Int)->Int{
        let monthLength = monthLengths[month]
        var comp = DateComponents()
        comp.day = monthLength
        comp.month = month
        comp.year = thisYear
        let date = calendar.date(from: comp)
        let weekDay = calendar.dateComponents([.weekday], from: date!)
        
        return weekDay.weekday!
    }
    
    static func weeksInMonth(forMonth month: Int)->Int{
        let noOfDays = monthLengths[month]
        var monthCompEnd = DateComponents()
        monthCompEnd.month = month
        monthCompEnd.day = noOfDays
        monthCompEnd.year = thisYear
        let monthEnd = calendar.date(from: monthCompEnd)
        
        let endWeekOfMonth = calendar.dateComponents([.weekOfMonth], from: monthEnd!).weekOfMonth!
        return endWeekOfMonth
        
    }
    static func determineIfEarlier(_ date:Date,date2: Date)-> Bool{
        var isEarlier: Bool = false
        
        let year1 =   calendar.component(.year, from: date )
        let year2 = calendar.component(.year, from: date2)
        let month1 = calendar.component(.month, from: date)
        let month2 = calendar.component(.month, from: date2)
        
        let comp1 = calendar.compare(date, to: date2, toGranularity: .day)
        let comp2 = calendar.compare(date, to: date2, toGranularity: .hour)
        let comp3 = calendar.compare(date , to: date2, toGranularity: .minute)
        let comp4 = calendar.compare(date , to: date2, toGranularity: .second)
        let earlierYear = year1 <= year2
        let earlierMonth = month1 <= month2
        let earlierYear_Month = earlierYear && earlierMonth
        if earlierYear_Month{
            switch comp1{
            case .orderedAscending:
                print("is earlier day")
                isEarlier = true
            case .orderedDescending:
                print("is later day")
                isEarlier = false
            case .orderedSame:
                print("is same day")
                switch comp2{
                case .orderedAscending:
                    print("is earlier hour")
                    isEarlier = true
                case .orderedDescending:
                    print("is later hour")
                    isEarlier = false
                case .orderedSame:
                    print("is same hour")
                    switch comp3{
                    case .orderedAscending:
                        print("is earlier minute")
                        isEarlier = true
                    case .orderedDescending:
                        print("is later Minute")
                        isEarlier = false
                    case .orderedSame:
                        print("is same minute")
                        switch comp4{
                        case .orderedAscending:
                            print("is earlier second")
                            isEarlier = true
                        case .orderedDescending:
                            print("is later second")
                            isEarlier = false
                        case .orderedSame:
                            print(" kinda rare but, is same second")
                            isEarlier = false
                        }
                        
                    }
                    
                }
            }
        }
        
        return isEarlier
    }
    static func daysOfMonth(_ month:Int)->[[Int]]{
        let monthLength = monthLengths[month]
        var comp = DateComponents()
        comp.day = 1
        comp.month = month
        comp.year = thisYear
        let monthStartDate = calendar.date(from: comp)
        let firstDay = firstWeekDay(forMonth: month)-1
        var comp2 = DateComponents()
        comp2.day = monthLength
        comp2.month = month
        comp2.year = thisYear
        let monthEndDate = calendar.date(from: comp2)
        let lastDay = lastWeekDay(forMonth: month)-1
        let weeks = weeksInMonth(forMonth: month)
        var arrayOfDays = [Int]()
        
        for day in 1...monthLength{
            arrayOfDays.append(day)
        }
        for i in 0..<firstDay{
            arrayOfDays.insert(0, at: 0)
        }
        for i in lastDay..<6{
            arrayOfDays.append(0)
        }
        let countInitial = arrayOfDays.count
        var allWeeks = [[Int]]()
        for i in 0...weeks{
            var week = [Int]()
            
            for i in 0...6{
                
                if arrayOfDays.count>0{
                    let day = arrayOfDays.first
                    week.append(day!)
                    
                    arrayOfDays.removeFirst()
                }
            }
            allWeeks.append(week )
            let countPost = arrayOfDays.count
        }
        return allWeeks
    }
    static func formattedDate(forDate date: Date)-> String{
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let theDate = "\(month)/\(day)/\(year)"
        
        return theDate
    }
    
    static  func timeSinceEvent(onDate date: Date)->String{
        var timeSince: String = ""
        let today = Date()
        let interval = Int(date.timeIntervalSince(today))
        let minute = 60
        let hour = 60*minute
        let day = 24*hour
        let week = 7*day
        let month = 4*week
        
        let minutesAgo = abs(interval/minute)
        let hoursAgo = abs(interval/hour)
        let daysAgo = abs(interval/day)
        let weeksAgo = abs(interval/week)
        let monthsAgo = abs(interval/month)
        
        if monthsAgo > 0{
            return "\(monthsAgo) mths ago"
        }
        if weeksAgo > 0{
            return "\(weeksAgo) wks ago"
        }
        if daysAgo > 0{
            return weekday(forDate: date)
        }
        if hoursAgo > 0{
            return time(forDate: date)
        }
        if minutesAgo > 1 && minutesAgo < 10{
            return "\(minutesAgo) minutes ago"
        }
        if minutesAgo < 1{
            return "Just now"
        }
        return time(forDate: date)
    }
    func dateFromString(date: String)->Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: -18000)
        let formattedDate = String(date.dropLast(6))
        formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        return formatter.date(from: formattedDate) ?? Date()
    }
    func stringFromDate(date: Date)->String{
        let month = Calendar.current.component(.month , from: date)
        let day = Calendar.current.component(.day , from: date)
        let year = Calendar.current.component(.year , from: date)
        let dayString = day < 10 ? "0"+String(describing:day) : String(describing: day)
        let dateString = "\(month)-\(dayString)-\(year)"
        return dateString
    }
    func formattedBday(bday: String)->String{
        let date = dateFromString(date: bday)
        let bdayString = stringFromDate(date: date)
        return bdayString
    }
    static  func generalTimeSinceEvent(onDate date: Date)->String{
        var timeSince: String = ""
        let today = Date()
        
        let days = Calendar.current.dateComponents([.day], from: today, to: date)
        
        let dayCount = days.day!
        
        
        let minutes = Calendar.current.dateComponents([.minute], from: today, to: date)
        
        let minuteCount = minutes.minute!
        
        if minuteCount > 60{
            let hour = minuteCount/60
            let hourMult: String = hour > 1 ? "hrs":"hr"
            timeSince = "\(hour) \(hourMult)"
        }else{
            
            let nowOrLater = minuteCount > 5 ? time(forDate: date) : "just now"
            let later = "\(minuteCount) min ago"
            timeSince = minuteCount > 20 ? later : nowOrLater
        }
        if dayCount > 0{
            let dayMultiple = dayCount > 1 ? "days" : "day"
            let day = formattedWeekday(forDate: date)
            
            timeSince =  dayCount < 4 ? day : "\(dayCount) \(dayMultiple)"
            
        }
        if dayCount > 7{
            let weeksAgo = dayCount/7
            let weekMultiple: String =  weeksAgo > 1 ? "wks" : "wk"
            timeSince = "\(weeksAgo) \(weekMultiple)"
        }
        
        if dayCount > 30{
            let monthsAgo = dayCount/30
            let monthMultiple: String =  monthsAgo > 1 ? "mths" : "mth"
            timeSince = "\(monthsAgo) \(monthMultiple)"
        }
        return timeSince
    }
}

