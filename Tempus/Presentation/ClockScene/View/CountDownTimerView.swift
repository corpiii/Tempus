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
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "progress")
        
        return view
    }()
    
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
    func setEmpty() {
        self.animationView.isHidden = false
        self.animationView.currentFrame = 0
        setRunningTime(0)
        self.remainTimeLabel.text = ""
    }
    
    func setRunningTime(_ runningTime: Double) {
        self.entireRunningTime = runningTime
        self.animationView.animationSpeed = 90 / entireRunningTime
    }
    
    func setTime(_ time: Time) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if self.entireRunningTime == .zero {
                self.remainTimeLabel.text = "지금은 대기시간 입니다. \n \(time.hour) : \(time.minute) : \(Int(time.second))"
                self.animationView.isHidden = true
            } else {
                if time.totalSecond > 0 {
                    let currentFrame = (1 - (time.totalSecond / self.entireRunningTime)) * Constant.totalFrame
                    let targetFrame = (1 - ((time.totalSecond - 1) / self.entireRunningTime)) * Constant.totalFrame
                    self.animationView.play(fromFrame: currentFrame, toFrame: targetFrame)
                }
                self.remainTimeLabel.text = "\(time.hour) : \(time.minute) : \(Int(time.second))"
                self.animationView.isHidden = false
            }
        }
    }
}
