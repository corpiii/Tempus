//
//  BlockCreateViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/10.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class BlockCreateViewController: UIViewController {
    private enum Constant {
        static let outerMagins: CGFloat = 20
        static let entireStackSpacing: CGFloat = 40
        static let divideCountStackSpacing: CGFloat = 40
        static let pickerViewWidth: CGFloat = 100
        static let divideCountCandidates: [String] = ["선택", "3", "4", "6", "8", "12"]
    }
    private let completeButton: UIBarButtonItem = .init(systemItem: .done)
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let divideCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constant.divideCountStackSpacing
        
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.placeholder = "제목"
        titleTextField.borderStyle = .roundedRect
        
        return titleTextField
    }()
    
    private let splittedClockView: SplittedClockView = {
        let clockView = SplittedClockView()
        
        return clockView
    }()
    
    private let divideCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단위 시간"
        
        return label
    }()
    
    private let divideCountPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    var viewModel: BlockCreateViewModel?
    private let disposeBag: DisposeBag = .init()
    private let textFieldSubject: PublishSubject<String> = .init()
    private let divideCountSubject: PublishSubject<Int> = .init()
    private let completeEvent: PublishSubject<Void> = .init()
    private let startEvent: PublishSubject<CompleteAlert> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    private func makeHeightDividerView() -> UIView {
        let emptyView = UIView()
        
        emptyView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(1)
        }
        
        return emptyView
    }
    
    private func makeWidthDividerView() -> UIView {
        let emptyView = UIView()
        
        emptyView.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(1)
        }
        
        return emptyView
    }
}

// MARK: - ConfigureUI
private extension BlockCreateViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureEntireStackView()
        configureDivideCountStackView()
        
        configureTitleTextField()
        configureSplittedClockView()
        configureDivideCountPickerView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = "새로 만들기"
        self.navigationItem.rightBarButtonItem = completeButton
        completeButton.target = self
        completeButton.action = #selector(completeButtonTapped)
    }
    
    @objc func completeButtonTapped(_ sender: UIBarButtonItem) {
        let selectRow = self.divideCountPickerView.selectedRow(inComponent: 0)
        let divideCount = Int(Constant.divideCountCandidates[selectRow]) ?? -1
        
        textFieldSubject.onNext(titleTextField.text ?? "")
        divideCountSubject.onNext(divideCount)
        completeEvent.onNext(())
        
        if let title = self.titleTextField.text, title.isEmpty == false,
           1 <= self.divideCountPickerView.selectedRow(inComponent: 0) {
            alertSuccess()
        } else {
            alertFailure()
        }
    }
    
    func alertSuccess() {
        let alert = UIAlertController(title: "생성 완료",
                                      message: "타이머를 바로 시작하시겠습니까?",
                                      preferredStyle: .alert)
        
        let completeWithStartAction = UIAlertAction(title: "예", style: .default) { [weak self] _ in
            self?.startEvent.onNext(.completeWithStart)
        }
        let completeWithoutStartAction = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
            let alert = UIAlertController(title: "저장",
                                          message: "저장되었습니다",
                                          preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.startEvent.onNext(.completeWithoutStart)
            }
            
            alert.addAction(confirmAction)
            
            self?.present(alert, animated: true)
        }
        
        alert.addAction(completeWithStartAction)
        alert.addAction(completeWithoutStartAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: "실패",
                                      message: "빈 값이 있는지 확인해주세요",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
    
    func configureEntireStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let emptyView = makeHeightDividerView()
        
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(titleTextField)
        entireStackView.addArrangedSubview(splittedClockView)
        entireStackView.addArrangedSubview(divideCountStackView)
        entireStackView.addArrangedSubview(emptyView)
        
//        entireStackView.backgroundColor = .systemRed
        entireStackView.spacing = Constant.entireStackSpacing
        
        entireStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeArea.snp.leading).offset(Constant.outerMagins)
            make.trailing.equalTo(safeArea.snp.trailing).offset(-Constant.outerMagins)
            make.top.equalTo(safeArea.snp.top).offset(Constant.outerMagins)
            make.bottom.equalTo(safeArea.snp.bottom).offset(-Constant.outerMagins)
        }
    }
    
    func configureDivideCountStackView() {
        let leftDividerView = makeWidthDividerView()
        let rightDividerView = makeWidthDividerView()
        
        divideCountStackView.addArrangedSubview(leftDividerView)
        divideCountStackView.addArrangedSubview(divideCountLabel)
        divideCountStackView.addArrangedSubview(divideCountPickerView)
        divideCountStackView.addArrangedSubview(rightDividerView)
        
        let stackWidthSize = self.view.frame.width - Constant.outerMagins * 2
        let allSpacing = 3 * Constant.divideCountStackSpacing
        let mainSize = Constant.pickerViewWidth + divideCountLabel.intrinsicContentSize.width + allSpacing
        let targetSize = (stackWidthSize - mainSize) / 2
        
        leftDividerView.snp.remakeConstraints { make in
            make.width.equalTo(targetSize)
        }
    }
    
    func configureTitleTextField() {
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(titleTextField.intrinsicContentSize.height)
        }
    }
    
    func configureSplittedClockView() {
        splittedClockView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(splittedClockView.snp.width)
        }
    }
    
    func configureDivideCountPickerView() {
        divideCountPickerView.dataSource = self
        divideCountPickerView.delegate = self
        
        divideCountPickerView.snp.makeConstraints { make in
            make.width.equalTo(Constant.pickerViewWidth)
        }
    }
}

// MARK: - BindViewModel
private extension BlockCreateViewController {
    func bindViewModel() {
        let input = BlockCreateViewModel.Input(modelTitle: textFieldSubject,
                                               modelDivideCount:  divideCountSubject,
                                               completeButtonTapEvent: completeEvent,
                                               startEvent: startEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag) else {
            return
        }
        
        bindCreateSuccess(output.isCreateSuccess)
    }
    
    func bindCreateSuccess(_ isCreateSuccess: PublishRelay<Bool>) {
        isCreateSuccess
            .subscribe(onNext: { [weak self] isCreateSuccess in
                guard let self else { return }
                isCreateSuccess
                ? self.alertSuccess()
                : self.alertFailure()
            }).disposed(by: disposeBag)
    }
}

extension BlockCreateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return divideCountStackView.bounds.height * 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        splittedClockView.splitClock(by: Constant.divideCountCandidates[row])
    }
}

extension BlockCreateViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.divideCountCandidates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.divideCountCandidates[row]
    }
}
