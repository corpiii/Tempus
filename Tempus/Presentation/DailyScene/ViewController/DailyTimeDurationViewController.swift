//
//  DailyTimeDurationViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/07.
//

import UIKit

import SnapKit

final class DailyTimeDurationViewController: UIViewController {
    private let doneBarButton: UIBarButtonItem = .init(systemItem: .done)
    
    // TODO: clockView
    private let blockClockView: DailyClockView = DailyClockView()
 
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
    
    init(viewModel: DailyTimeDurationCreateViewModel) {
        self.viewModel = viewModel
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
}

// MARK: - ConfigureUI
private extension DailyTimeDurationViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        configureEntireStackView()
        configureBlockClockView()
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
        
        entireStackView.addArrangedSubview(blockClockView)
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
    
    func configureBlockClockView() {
        
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
        blockClockView.setStartTime(sender.date)
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
        blockClockView.setRepeatCount(Int(sender.value))
    }
}


// MARK: - BindViewModel
private extension DailyTimeDurationViewController {
    func bindViewModel() {
        
    }
}
