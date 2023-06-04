//
//  DailyInfoCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/04.
//

import UIKit

import RxSwift

class DailyInfoCreateViewController: UIViewController {

    private let cancelButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let nextButton: UIBarButtonItem = .init()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목"
        
        return textField
    }()
    
    private let focusTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "집중시간"
        
        return label
    }()
    
    private let focusTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let breakTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "휴식시간"
        
        return label
    }()
    
    private let breakTimeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private weak var viewModel: DailyInfoEditViewModel?
    private let disposeBag: DisposeBag = .init()
    
    private let modelTitleSubject: PublishSubject<String> = .init()
    private let modelFocusTimeSubject: PublishSubject<Double> = .init()
    private let modelBreakTimeSubject: PublishSubject<Double> = .init()
    private let nextButtonTappedEvent: PublishSubject<Void> = .init()
    private let cancelButtonTappedEvent: PublishSubject<Void> = .init()
    
    init(viewModel: DailyInfoEditViewModel) {
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
private extension DailyInfoCreateViewController {
    func configureUI() {
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새로 만들기"
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = nextButton
        
//        cancelButton.target = self
//        cancelButton.action = #selector(cancelBarButtonTapped)
        
        nextButton.target = self
        nextButton.action = #selector(nextBarButtonTapped)
    }
    
//    @objc func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
//        print("cancel Button tapped")
//    }
    
    @objc func nextBarButtonTapped(_ sender: UIBarButtonItem) {
        print("next Button tapped")
    }
}

// MARK: - BindViewModel
private extension DailyInfoCreateViewController {
    func bindViewModel() {
        let input = DailyInfoEditViewModel.Input(nextButtonTapEvent: nextButtonTappedEvent,
                                                 cancelButtonTapEvent: cancelButton.rx.tap.asObservable(),
                                                 modelTitle: modelTitleSubject,
                                                 modelFocusTime: modelFocusTimeSubject,
                                                 modelBreakTime: modelBreakTimeSubject)
        
        guard let output = viewModel?.transform(input: input, disposeBag: self.disposeBag) else {
            return
        }
        
        output.isFillAllInfo
            .subscribe(onNext: { [weak self] isFillAllInfo in
                if isFillAllInfo == false {
                    self?.alertFailure()
                }
            }).disposed(by: self.disposeBag)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: "실패",
                                      message: "빈 값이 있는지 확인해주세요",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}
