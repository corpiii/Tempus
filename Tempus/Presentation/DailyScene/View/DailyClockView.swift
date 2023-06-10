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
    
    private let focusTime: Double
    private let breakTime: Double
    
    private var startTime: Date?
    private var startAngle: CGFloat = Constant.topAngle
    private var repeatCount: Int = 1
    
    init(focusTime: Double, breakTime: Double) {
        self.focusTime = focusTime
        self.breakTime = breakTime
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawClockLine()
    }
    
    func setStartTime(_ startTime: Date) {
        self.startTime = startTime
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime)
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let totalMinutes = (hour * 60 + minute) * Constant.degree
        
        self.startAngle = Constant.topAngle + totalMinutes * .pi / 180
        
        // draw
        drawClockLine()
    }
    
    func setRepeatCount(_ repeatCount: Int) {
        self.repeatCount = repeatCount
        
        // draw
        drawClockLine()
    }
}

private extension DailyClockView {
    func drawClockLine() {
        print("draw")
    }
}
