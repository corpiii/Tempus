//
//  BlockTableViewDataSourceManager.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/01.
//

import UIKit

struct BlockTableViewDataSourceManager: TableViewDataSourceManager {
    typealias Model = BlockModel
    
    enum Section {
        case main
    }

    var dataSource: UITableViewDiffableDataSource<Section, BlockModel>

    init(tableView: UITableView) {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockCell.identifier, for: indexPath) as? BlockCell else {
                return UITableViewCell()
            }

            cell.modelTitleLabel.text = model.title
            return cell
        })

        tableView.dataSource = dataSource

        var snapShot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
        snapShot.appendSections([.main])
        dataSource.apply(snapShot)

    }

    func apply(section: Section, models: [BlockModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, BlockModel>()
        snapShot.appendSections([section])
        snapShot.appendItems(models)

        dataSource.apply(snapShot)
    }

    func delete(model: BlockModel) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([model])

        self.dataSource.apply(snapshot)
    }

    func fetch(index: Int) -> BlockModel {
        let snapShot = dataSource.snapshot()
        let model = snapShot.itemIdentifiers[index]

        return model
    }
}
