//
//  CountDownTimerView.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/20.
//

import UIKit

import Lottie

class CountDownTimerView: UIView {
    private enum Constant {
        static let totalFrame: Double = 900
    }
    
    private let animationView: LottieAnimationView = .init(name: "progress")
    private var entireRunningTime: Double = 0
    private let remainTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
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
        setupClockCircle()
        setupCountDownLabel()
    }
    
    func setupClockCircle() {
        addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.center.equalTo(circleCenter)
            make.width.equalTo(circleRadius * 2)
            make.height.equalTo(animationView.snp.width)
        }
    }
    
    func setupCountDownLabel() {
        addSubview(remainTimeLabel)
        
        remainTimeLabel.font = .preferredFont(forTextStyle: .title1)
        
        remainTimeLabel.snp.makeConstraints { make in
            make.center.equalTo(circleCenter)
        }
    }
}

extension CountDownTimerView {
    func setRunningTime(_ runningTime: Double) {
        self.entireRunningTime = runningTime
    }
    
    func setTime(_ time: Time) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.animationView.currentFrame = (1 - (time.totalSecond / self.entireRunningTime)) * Constant.totalFrame
            
            if self.entireRunningTime == .zero {
                self.remainTimeLabel.text = "지금은 대기시간 입니다. \n \(time.hour) : \(time.minute) : \(Int(time.second))"
            } else {
                self.remainTimeLabel.text = "\(time.hour) : \(time.minute) : \(Int(time.second))"
            }
        }
    }
}
