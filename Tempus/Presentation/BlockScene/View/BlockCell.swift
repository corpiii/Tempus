//
//  BlockCell.swift
//  Tempus
//
//  Created by 이정민 on 2023/05/29.
//

import UIKit

import SnapKit

class BlockCell: UITableViewCell {
    let modelTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BlockCell {
    func configureUI() {
        self.addSubview(modelTitleLabel)
        
        modelTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).inset(30)
            make.trailing.equalTo(self.snp.trailing).inset(30)
//            make.centerX.equalTo(self.snp.centerX)
            
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
