//
//  SplittedClockView.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/10.
//

import UIKit

final class BlockClockView: ClockView {
    private var ClockInterval: String = ""
    private var splitLayer = CALayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        splitClock(by: ClockInterval)
    }
    
    func splitClock(by interval: String) {
        splitLayer.removeFromSuperlayer()
        layer.layoutIfNeeded()
        
        self.ClockInterval = interval
        guard let interval = Int(interval) else { return }
        let divideCount = 24 / interval
        let startAngle = -90 * CGFloat.pi / 180
        let angleInterval = CGFloat.pi * 2 / CGFloat(divideCount)
        
        splitLayer = CALayer()
        
        for i in 0..<divideCount {
            let angle = startAngle + CGFloat(i) * angleInterval
            let arkLayer = CAShapeLayer()
            let arkPath = UIBezierPath()

            arkPath.move(to: circleCenter)
            arkPath.addArc(withCenter: circleCenter, radius: radius,
                           startAngle: angle, endAngle: angle + angleInterval, clockwise: true)
            arkPath.close()

            arkLayer.path = arkPath.cgPath

            arkLayer.lineWidth = 2.0
            arkLayer.strokeColor = UIColor.red.cgColor
            arkLayer.fillColor = Constant.splittedBackGroundColor

            splitLayer.addSublayer(arkLayer)
        }
        
        layer.addSublayer(splitLayer)
    }
}
