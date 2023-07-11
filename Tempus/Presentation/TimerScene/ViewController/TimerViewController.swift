//
//  TimerViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/20.
//

import UIKit

import RxSwift
import LGButton

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
    
    private let wasteTimePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .countDownTimer
        
        return datePicker
    }()
    
    private let startButton: LGButton = {
        let button = LGButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleString = "시작"
        button.bgColor = ColorConstant.firstColor
        button.titleFontName = "AppleSDGothicNeo-Bold"
        button.titleFontSize = UIFont.buttonFontSize
        button.cornerRadius = 10
        
        return button
    }()
    
    private weak var viewModel: TimerViewModel?
    private let disposeBag: DisposeBag = .init()
    private let wasteTimeSubject: PublishSubject<Date> = .init()
    private let startButtonTapEvent: PublishSubject<Void> = .init()
    
    init(viewModel: TimerViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorConstant.backGroundColor
        configureUI()
        bindViewModel()
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
        self.entireStackView.addArrangedSubview(wasteTimePicker)
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
        self.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.startButton.isSelected = true
        
        let safeArea = self.view.safeAreaLayoutGuide
        self.startButton.snp.makeConstraints { make in
            make.height.equalTo(safeArea.snp.height).multipliedBy(0.05)
        }
    }

    @objc private func startButtonTapped() {
        wasteTimeSubject.onNext(wasteTimePicker.date)
        startButtonTapEvent.onNext(())
    }
}

private extension TimerViewController {
    func bindViewModel() {
        let input = TimerViewModel.Input(modelWasteTime: wasteTimeSubject,
                                         startButtonTapEvent: startButtonTapEvent)
        
        viewModel?.bind(input: input, disposeBag: disposeBag)
    }
}
