//
//  SplittedClockView.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/10.
//

import UIKit

class SplittedClockView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Set the fill color to blue
        UIColor.blue.setFill()
        
        // Calculate the center point
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Calculate the radius as half of the minimum side length
        let radius = min(rect.width, rect.height) / 2.0 - 10
        
        // Create a circular path with the center and radius
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        // Fill the path to draw the circle
        path.fill()
    }

}
