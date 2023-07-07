//
//  BlockEditViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/17.
//

import UIKit

import RxSwift
import SnapKit

final class BlockEditViewController: UIViewController {
    private enum Constant {
        static let outerMagins: CGFloat = 20
        static let entireStackSpacing: CGFloat = 40
        static let divideCountStackSpacing: CGFloat = 40
        static let pickerViewWidth: CGFloat = 100
        static let blockTimeCandidates: [String] = ["선택", "3", "4", "6", "8", "12"]
    }
    
    private let backBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "arrow.backward"))
    private let doneButton: UIBarButtonItem = .init(systemItem: .done)
    
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
    
    private let splittedClockView: BlockClockView = {
        let clockView = BlockClockView()
        
        return clockView
    }()
    
    private let divideCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "시간 간격"
        
        return label
    }()
    
    private let divideCountPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    private weak var viewModel: BlockEditViewModel?
    private let disposeBag: DisposeBag = .init()
    private let textFieldSubject: PublishSubject<String> = .init()
    private let blockTimeSubject: PublishSubject<Int> = .init()
    private let doneButtonTapEvent: PublishSubject<Void> = .init()
    private let completeEvent: PublishSubject<Void> = .init()
    
    init(viewModel: BlockEditViewModel) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
private extension BlockEditViewController {
    func configureUI() {
        self.view.backgroundColor = ColorConstant.fourthColor
        configureNavigationBar()
        configureEntireStackView()
        configureDivideCountStackView()
        
        configureTitleTextField()
        configureSplittedClockView()
        configureDivideCountPickerView()
    }
    
    func configureNavigationBar() {
        self.navigationItem.leftBarButtonItem = backBarButton
        
        self.navigationItem.title = "수정하기"
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.target = self
        doneButton.action = #selector(completeButtonTapped)
    }
    
    @objc func completeButtonTapped(_ sender: UIBarButtonItem) {
        let blockTime = Int(Constant.blockTimeCandidates[divideCountPickerView.selectedRow(inComponent: 0)]) ?? -1
        
        textFieldSubject.onNext(titleTextField.text ?? "")
        blockTimeSubject.onNext(blockTime)
        doneButtonTapEvent.onNext(())
    }
    
    func configureEntireStackView() {
        let safeArea = self.view.safeAreaLayoutGuide
        let emptyView = makeHeightDividerView()
        
        self.view.addSubview(entireStackView)
        entireStackView.addArrangedSubview(titleTextField)
        entireStackView.addArrangedSubview(splittedClockView)
        entireStackView.addArrangedSubview(divideCountStackView)
        entireStackView.addArrangedSubview(emptyView)
        
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
private extension BlockEditViewController {
    func bindViewModel() {
        let input = BlockEditViewModel.Input(modelTitle: textFieldSubject,
                                             modelBlockTime: blockTimeSubject,
                                             doneButtonTapEvent: doneButtonTapEvent,
                                             backButtonTapEvent: backBarButton.rx.tap.asObservable(),
                                             completeEvent: completeEvent)
        
        guard let output = viewModel?.transform(input: input, disposeBag: disposeBag),
              let pickerIndex = Constant.blockTimeCandidates.firstIndex(of: "\(output.blockTime)") else {
            return
        }
        
        self.titleTextField.text = output.title
        self.divideCountPickerView.selectRow(pickerIndex, inComponent: 0, animated: true)
        
        DispatchQueue.main.async {
            self.splittedClockView.splitClock(by: "\(output.blockTime)")
        }
        
        bindEditSuccess(output.isEditSuccess, disposeBag)
    }
    
    func bindEditSuccess(_ isEditSuccess: PublishSubject<Bool>, _ disposeBag: DisposeBag) {
        isEditSuccess
            .subscribe(onNext: { [weak self] isEditSuccess in
                guard let self else { return }
                
                isEditSuccess
                ? self.completeEvent.onNext(())
                : self.alertFailure()
                
            }).disposed(by: disposeBag)
    }
    
    func alertFailure() {
        let alert = UIAlertController(title: "실패",
                                      message: "수정이 실패했습니다. \n 빈값이 있는지 확인해주세요.",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirmAction)
        
        self.present(alert, animated: true)
    }
}

extension BlockEditViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return divideCountStackView.bounds.height * 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        splittedClockView.splitClock(by: Constant.blockTimeCandidates[row])
    }
}

extension BlockEditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.blockTimeCandidates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.blockTimeCandidates[row]
    }
}
