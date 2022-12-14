//
//  Manger.swift
//  WeatherApp
//
//  Created by MacOS on 12/12/2022.
//

import Foundation

class Manager {
    public static var shared = Manager()
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday
        return formatter.string(from: inputDate)
    }
    
    func getHourForDate(date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "hh a" // Monday
        return formatter.string(from: inputDate)
    
    }
    
    func changeDegreeFromFToC(degree: Double) -> Int{
        return Int((degree - 32) * 5 / 9)
    }
}
