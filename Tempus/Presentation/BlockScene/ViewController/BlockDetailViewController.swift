//
//  BlockDetailViewController.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/13.
//

import UIKit

class BlockDetailViewController: UIViewController {

    var viewModel: BlockDetailViewModel?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let clockView: SplittedClockView = {
        let clockView = SplittedClockView()
        clockView.translatesAutoresizingMaskIntoConstraints = false
        
        return clockView
    }()
    
    private let cancelBarButton: UIBarButtonItem = .init(systemItem: .cancel)
    private let editBarButton: UIBarButtonItem = .init(systemItem: .edit)
    private let startBarButton: UIBarButtonItem = .init(title: "시작")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - ConfigureUI
private extension BlockDetailViewController {
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        configureNavigationBar()
//        configureTitleLabel()
//        configureClockView()
    }
    
    func configureNavigationBar() {
//        self.navigationItem.title = "블록"
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelBarButtonTapped)
        
        editBarButton.target = self
        editBarButton.action = #selector(editBarButtonTapped)
        
        startBarButton.target = self
        startBarButton.action = #selector(startBarButtonTapped)
        
        self.navigationItem.leftBarButtonItem = cancelBarButton
        self.navigationItem.rightBarButtonItems = [startBarButton, editBarButton]
    }
}

// MARK: - ButtonTappedAction
private extension BlockDetailViewController {
    @objc func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func startBarButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}
