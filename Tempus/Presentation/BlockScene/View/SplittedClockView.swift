//
//  SplittedClockView.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/10.
//

import UIKit

class SplittedClockView: UIView {
    private enum Constant {
        static let lineColor: CGColor = UIColor.black.cgColor
        static let lineWidth: CGFloat = 2.0
        static let clockBackgroundColor: CGColor = UIColor.systemGray6.cgColor
        static let startAngle: CGFloat = -75 * CGFloat.pi / 180
        
        static let dotRadius: CGFloat = 3.0
        static let numberSize: CGFloat = 12
        static let distanceFromDot: CGFloat = 20
    }
    
    private lazy var circleCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    private lazy var radius = bounds.width * 0.9 / 2.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupBaseLine()
        setupDots()
    }
    
    private func setupBaseLine() {
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = Constant.lineColor
        circleLayer.fillColor = Constant.clockBackgroundColor
        
        let path = UIBezierPath(arcCenter: circleCenter, radius: radius,
                                startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        circleLayer.lineWidth = Constant.lineWidth
        circleLayer.path = path.cgPath
        
        layer.addSublayer(circleLayer)
    }
    
    private func setupDots() {
        let dotCount = 24
        let angleInterval = CGFloat.pi * 2 / CGFloat(dotCount)
        
        for i in 0..<dotCount {
            let angle = Constant.startAngle + CGFloat(i) * angleInterval
            
            let dotCenterX = circleCenter.x + radius * cos(angle)
            let dotCenterY = circleCenter.y + radius * sin(angle)
            let dotCenter = CGPoint(x: dotCenterX, y: dotCenterY)
            
            let dotPath = UIBezierPath(arcCenter: dotCenter, radius: Constant.dotRadius,
                                       startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            
            let dotLayer = CAShapeLayer()
            dotLayer.path = dotPath.cgPath
            dotLayer.fillColor = Constant.lineColor
            layer.addSublayer(dotLayer)
            
            let numberLabel = UILabel()
            numberLabel.text = "\(i + 1)"
            numberLabel.font = UIFont.systemFont(ofSize: Constant.numberSize)
            numberLabel.sizeToFit()
            numberLabel.center = CGPoint(x: dotCenterX, y: dotCenterY)
            
            let distanceFromDot = Constant.dotRadius - Constant.distanceFromDot
            numberLabel.center.x += distanceFromDot * cos(angle)
            numberLabel.center.y += distanceFromDot * sin(angle)
            
            addSubview(numberLabel)
        }
    }
}
