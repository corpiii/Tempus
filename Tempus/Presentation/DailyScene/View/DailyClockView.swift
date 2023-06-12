//
//  DailyClockVIew.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

class DailyClockView: ClockView {
    private enum Constant {
        static let degree: Double = 0.25
        static let topAngle: CGFloat = -90 * .pi / 180
        static let focusTimeColor: UIColor = .init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        static let breakTimeColor: UIColor = .init(red: 0.23, green: 0.23, blue: 0.23, alpha: 0.5)
    }
    
    private let focusTime: Double
    private var focusTimeAngle: CGFloat {
        convertToRadian(from: focusTime)
    }
    
    private let breakTime: Double
    private var breakTimeAngle: CGFloat {
        convertToRadian(from: breakTime)
    }
    
    private var startTime: Date?
    private var startAngle: CGFloat = Constant.topAngle
    private var repeatCount: Int = 1
    
    private var splitLayer = CALayer()
    
    weak var alertDelegate: AlertRepeatCountOverDelegate?
    
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
    
    private func convertToRadian(from time: Double) -> CGFloat {
        let ratio = time / 3600 / 24 * 360 // 24시 표기 시계의 몇도인가
        let radian = ratio * .pi / 180
        
        return radian
    }
    
    func setStartTime(_ startTime: Date) {
        self.startTime = startTime
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime)
        let hour = Double(components.hour ?? 0)
        let minute = Double(components.minute ?? 0)
        let totalMinutes = (hour * 60 + minute) * Constant.degree
        
        self.startAngle = Constant.topAngle + totalMinutes * .pi / 180
        
        drawClockLine()
    }
    
    func setRepeatCount(_ repeatCount: Int) {
        let endAngle = startAngle + CGFloat(repeatCount) * (focusTimeAngle + breakTimeAngle)
        
        if endAngle - startAngle >= 2 * CGFloat.pi {
            alertDelegate?.alertRepeatCountOver()
        } else {
            self.repeatCount = repeatCount
            drawClockLine()
        }
    }
}

private extension DailyClockView {
    func drawClockLine() {
        splitLayer.removeFromSuperlayer()
        splitLayer = CAShapeLayer()
        layer.layoutIfNeeded()
        
        for i in 1...repeatCount {
            let startTimeAngle = startAngle + CGFloat(i - 1) * (focusTimeAngle + breakTimeAngle)

            let focusTimeEndAngle = startTimeAngle + focusTimeAngle
            let breakTimeEndAngle = focusTimeEndAngle + breakTimeAngle

            let focusTimeLayer = generateTimeLineLayer(startAngle: startTimeAngle, endAngle: focusTimeEndAngle, color: Constant.focusTimeColor)
            splitLayer.addSublayer(focusTimeLayer)

            let breakTimeLayer = generateTimeLineLayer(startAngle: focusTimeEndAngle, endAngle: breakTimeEndAngle, color: Constant.breakTimeColor)
            splitLayer.addSublayer(breakTimeLayer)
        }
        
        layer.addSublayer(splitLayer)
    }
    
    func generateTimeLineLayer(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) -> CAShapeLayer {
        let timeLayer = CAShapeLayer()
        let arkPath = UIBezierPath()
        
        arkPath.move(to: circleCenter)
        arkPath.addArc(withCenter: circleCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        timeLayer.path = arkPath.cgPath
        
        timeLayer.lineWidth = 2.0
        timeLayer.fillColor = color.cgColor
        
        return timeLayer
    }
}
