//
//  DailyTimeDurationCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

import RxSwift
import SnapKit

final class DailyTimeDurationCreateViewController: UIViewController {
    private let doneBarButton: UIBarButtonItem = .init(systemItem: .done)
    
    // TODO: clockView
    private let dailyClockView: DailyClockView
 
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let startTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시작 시간"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 5
        
        return picker
    }()
    
    private let repeatCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let repeatCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "반복 횟수"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let repeatCountStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        
        return stepper
    }()
    
    private weak var viewModel: DailyTimeDurationCreateViewModel?
    private let startTimeSubject: PublishSubject<Double> = .init()
    private let repeatCountSubject: PublishSubject<Int> = .init()
    private let backButtonTapEvent: PublishSubject<Void> = .init()
    private let doneButtonTapEvent: PublishSubject<CompleteAlert> = .init()
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: DailyTimeDurationCreateViewModel, focusTime: Double, breakTime: Double) {
        self.viewModel = viewModel
        self.dailyClockView = .init(focusTime: focusTime, breakTime: breakTime)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dailyClockView.setStartTime(startTimePicker.date)
    }
}

// MARK: - ConfigureUI
private extension DailyTimeDurationCreateViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        configureEntireStackView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새로 만들기"
        
        self.navigationItem.rightBarButtonItem = doneBarButton
        doneBarButton.target = self
        doneBarButton.action = #selector(doneBarButtonTapped)
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: create event to viewModel
    }
    
    func configureEntireStackView() {
        self.view.addSubview(entireStackView)
        
        entireStackView.addArrangedSubview(dailyClockView)
        entireStackView.addArrangedSubview(startTimeStackView)
        entireStackView.addArrangedSubview(repeatCountStackView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        entireStackView.spacing = 10
        entireStackView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea.snp.edges).inset(20)
        }
        
        configureStartTimeStackView()
        configureRepeatCountStackView()
    }
    
    func configureStartTimeStackView() {
        startTimeStackView.addArrangedSubview(startTimeLabel)
        startTimeStackView.addArrangedSubview(startTimePicker)
        
        // spacing?
        
        configureStartTimePicker()
    }
    
    func configureStartTimePicker() {
        startTimePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        dailyClockView.setStartTime(sender.date)
    }
    
    func configureRepeatCountStackView() {
        repeatCountStackView.addArrangedSubview(repeatCountLabel)
        repeatCountStackView.addArrangedSubview(repeatCountStepper)
        
        // spacing?
        
        configureRepeatCountStepper()
    }
    
    func configureRepeatCountStepper() {
        repeatCountStepper.minimumValue = 1
        repeatCountStepper.addTarget(self, action: #selector(stepperTapped), for: .touchUpInside)
    }
    
    @objc func stepperTapped(_ sender: UIStepper) {
        dailyClockView.setRepeatCount(Int(sender.value))
    }
}


// MARK: - BindViewModel
private extension DailyTimeDurationCreateViewController {
    func bindViewModel() {
        let input = DailyTimeDurationCreateViewModel.Input(startTime: startTimeSubject,
                                                           repeatCount: repeatCountSubject,
                                                           backButtonTapEvent: backButtonTapEvent,
                                                           completeButtonTapEvent: doneButtonTapEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else { return }
        
        output.isCreateSuccess
            .subscribe(onNext: { isCreateSuccess in
                // alert
            }).disposed(by: disposeBag)
    }
}
