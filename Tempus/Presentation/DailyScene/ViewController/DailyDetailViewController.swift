//
//  DailyDetailViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/17.
//

import UIKit

import RxSwift

class DailyDetailViewController: UIViewController {
    private let backBarButton: UIBarButtonItem = .init(image: UIImage(systemName: "arrow.backward"))
    private let editBarButton: UIBarButtonItem = .init(systemItem: .edit)
    private let startBarButton: UIBarButtonItem = .init(title: "시작")
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dailyClockView: DailyClockView
    private weak var viewModel: DailyDetailViewModel?
    private let disposeBag: DisposeBag = .init()
    
    init(viewModel: DailyDetailViewModel, startTime: Date, focusTime: Double, breakTime: Double) {
        self.viewModel = viewModel
        self.dailyClockView = .init(startTime: startTime, focusTime: focusTime, breakTime: breakTime)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        configureUI()
        bindViewModel()
    }
}

// MARK: - ConfigureUI
private extension DailyDetailViewController {
    func configureUI() {
    }
}


// MARK: - BindViewModel
private extension DailyDetailViewController {
    func bindViewModel() {
        
    }
}
