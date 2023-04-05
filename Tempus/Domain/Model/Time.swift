//
//  Time.swift
//  Tempus
//
//  Created by 이정민 on 2023/04/04.
//

struct Time {
    private(set) var hour: Int
    private(set) var minute: Int
    private(set) var second: Int
    
    init(second: Double) {
        let second = Int(second)
        
        self.hour = second / 3600
        self.minute = second / 60 % 60
        self.second = second % 60
    }
    
    mutating func flowOneSecond() {
        self.second -= 1
        
        if self.second == -1 {
            self.minute -= 1
            self.second += 60
        }
        
        if self.minute == -1 {
            self.hour -= 1
            self.minute += 60
        }
    }
}
