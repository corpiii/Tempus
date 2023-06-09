//
//  DailyClockVIew.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import Foundation

class DailyClockView: ClockView {
    private enum Constant {
        static let degree: Double = 0.25
        static let topAngle: CGFloat = -90 * .pi / 180
    }
    
    private var startAngle: CGFloat = Constant.topAngle
    private var repeatCount: Int = 1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    func setStartTime(_ startTime: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime)
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let totalMinutes = (hour * 60 + minute) * Constant.degree
        
        startAngle = Constant.topAngle + totalMinutes * .pi / 180
    }
    
    func setRepeatCount(_ repeatCount: Int) {
        
    }
}
