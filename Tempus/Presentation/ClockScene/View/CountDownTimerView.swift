//
//  CountDownTimerView.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/20.
//

import UIKit

import Lottie

class CountDownTimerView: UIView {

    private let animationView: LottieAnimationView = .init(name: "progress")
    
    private let remainTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var circleCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    private lazy var circleRadius = bounds.width * 0.95 / 2.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupBaseLine()
    }
}

private extension CountDownTimerView {
    func setupBaseLine() {
        // 원 레이어 추가
        setupClockCircle()
        
        // 라벨 레이어 추가
        setupCountDownLabel()
    }
    
    func setupClockCircle() {
        addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.center.equalTo(circleCenter)
            make.width.equalTo(circleRadius * 2)
            make.height.equalTo(animationView.snp.width)
        }
        
        animationView.play()
    }
    
    func setupCountDownLabel() {
        addSubview(remainTimeLabel)
        
        remainTimeLabel.text = "rerere"
        
        remainTimeLabel.snp.makeConstraints { make in
            make.center.equalTo(circleCenter)
        }
    }
}
