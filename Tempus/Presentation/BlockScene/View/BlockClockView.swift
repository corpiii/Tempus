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
    
    private var splittedStrokeColor: CGColor = UIColor(red: 96 / 255.0,
                                                       green: 105 / 255.0,
                                                       blue: 143 / 255.0,
                                                       alpha: 56 / 100.0).cgColor
    private let radiusRatio: Double = 0.8
    
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
            arkPath.addArc(withCenter: circleCenter, radius: radius * radiusRatio,
                           startAngle: angle, endAngle: angle + angleInterval, clockwise: true)
            arkPath.close()

            arkLayer.path = arkPath.cgPath

            arkLayer.lineWidth = 2.0
            arkLayer.strokeColor = UIColor.systemBackground.cgColor
            arkLayer.fillColor = ColorConstant.firstColor.cgColor

            splitLayer.addSublayer(arkLayer)
        }
        
        layer.addSublayer(splitLayer)
    }
}
