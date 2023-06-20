//
//  TimerViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/20.
//

import UIKit

import SSBouncyButton

class TimerViewController: UIViewController {
    private enum Constant {
        static let outerMargin: CGFloat = 20
    }
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let focusTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .countDownTimer
        
        return datePicker
    }()
    
    private let startButton: SSBouncyButton = {
        let button = SSBouncyButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("시작", for: .normal)
        button.tintColor = .darkGray
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureUI()
    }
}

// MARK: - ConfigureUI
private extension TimerViewController {
    func configureUI() {
        configureEntireStackView()
    }
    
    func configureEntireStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let spacing = safeArea.layoutFrame.height * 0.1
        
        self.view.addSubview(entireStackView)
        self.entireStackView.addArrangedSubview(focusTimePicker)
        self.entireStackView.addArrangedSubview(startButton)
        
        self.entireStackView.spacing = spacing
        configureStartButton()
        
        self.entireStackView.snp.makeConstraints { make in
            let inset = Constant.outerMargin
            
            make.leading.equalTo(safeArea.snp.leading).inset(inset)
            make.trailing.equalTo(safeArea.snp.trailing).inset(inset)
            make.centerY.equalTo(safeArea.snp.centerY)
        }
    }
    
    func configureStartButton() {
        self.startButton.isSelected = true
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.startButton.snp.makeConstraints { make in
            make.height.equalTo(safeArea.snp.height).multipliedBy(0.05)
        }
    }

}
