//
//  TableViewDataSourceManager.swift
//  Tempus
//
//  Created by 이정민 on 2023/06/03.
//

protocol TableViewDataSourceManager {
    associatedtype Section: Hashable
    associatedtype Model: Hashable
    
    var dataSource: UITableViewDiffableDataSource<Section, Model> { get set }
    
    func apply(section: Section, models: [Model])
    func delete(model: Model)
    func fetch(index: Int) -> Model
}
