//
//  DailyTableViewDataSourceManager.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/03.
//

import UIKit

struct DailyTableViewDataSourceManager: TableViewDataSourceManager {
    typealias Model = DailyModel
    
    enum Section {
        case main
    }

    var dataSource: UITableViewDiffableDataSource<Section, Model>

    init(tableView: UITableView) {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyCell.identifier, for: indexPath) as? DailyCell else {
                return UITableViewCell()
            }

//            cell.modelTitleLabel.text = model.title
            return cell
        })
        
        dataSource.defaultRowAnimation = .none
        tableView.dataSource = dataSource

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
