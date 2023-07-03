//
//  DailyCell.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/03.
//

import UIKit

import SnapKit

final class DailyCell: UITableViewCell {
    let modelTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DailyCell {
    func configureUI() {
        self.addSubview(modelTitleLabel)
        
        modelTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(30)
            make.trailing.equalTo(self.snp.trailing).inset(30)
            
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
