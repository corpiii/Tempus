//
//  ClockViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/19.
//

import UIKit

import SnapKit

class ClockViewController: UIViewController {
    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        
        return button
    }()
    
    private let countDownTimerView: CountDownTimerView = .init()
    
    var viewModel: ClockViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelfView()
        configureUI()
    }
}

private extension ClockViewController {
    func configureSelfView() {
        self.view.backgroundColor = .systemBackground
    }
    
    func configureUI() {
        // 시계 뷰
        configureTimerView()
        
        // 시작버튼
    }
    
    func configureTimerView() {
        self.view.addSubview(countDownTimerView)
        countDownTimerView.backgroundColor = .systemRed
        
        let safeArea = self.view.safeAreaLayoutGuide
        countDownTimerView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading)
            make.trailing.equalTo(safeArea.snp.trailing)
            
            make.height.equalTo(countDownTimerView.snp.width)
            make.centerY.equalTo(safeArea.snp.centerY)
        }
    }
}
