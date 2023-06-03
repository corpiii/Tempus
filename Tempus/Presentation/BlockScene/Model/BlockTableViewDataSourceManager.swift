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

    var dataSource: UITableViewDiffableDataSource<Section, Model>

    init(tableView: UITableView) {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockCell.identifier, for: indexPath) as? BlockCell else {
                return UITableViewCell()
            }

            cell.modelTitleLabel.text = model.title
            return cell
        })
        dataSource.defaultRowAnimation = .none
        tableView.dataSource = dataSource
        tableView.register(BlockCell.self, forCellReuseIdentifier: BlockCell.identifier)

        var snapShot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapShot.appendSections([.main])
        dataSource.apply(snapShot)
    }

    func append(section: Section, models: [Model]) {
        var snapShot = self.dataSource.snapshot()
        snapShot.appendItems(models)
        
        dataSource.apply(snapShot)
    }

    func delete(model: Model) {
        var snapshot = self.dataSource.snapshot()
        snapshot.deleteItems([model])

        self.dataSource.apply(snapshot)
    }

    func fetch(index: Int) -> Model {
        let snapShot = self.dataSource.snapshot()
        let model = snapShot.itemIdentifiers[index]

        return model
    }
}
