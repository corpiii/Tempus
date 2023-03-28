//
//  CoreDataRepository.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import CoreData
import Foundation

class CoreDataRepository: DataManagerRepository {
    enum Constant {
        static let TimerEntityName = "TimerEntity"
        static let BlockEntityName = "BlockEntity"
        static let DailyEntityName = "DailyEntity"
    }
    
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

// MARK: - Create Method
extension CoreDataRepository {
    func create(mode: TimerModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: Constant.TimerEntityName, in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.wasteTime, forKey: "wasteTime")
        
        try context.save()
    }
    
    func create(mode: BlockModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: Constant.BlockEntityName, in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.divideCount, forKey: "divideCount")
        
        try context.save()
    }
    
    func create(mode: DailyModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: Constant.BlockEntityName, in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.startTime, forKey: "startTime")
        newObject.setValue(mode.repeatCount, forKey: "repeatCount")
        newObject.setValue(mode.focusTime, forKey: "focusTime")
        newObject.setValue(mode.breakTime, forKey: "breakTime")
        
        try context.save()
    }
}

// MARK: - Fetch Method
extension CoreDataRepository {
    func fetch() throws -> [TimerModel] {
        <#code#>
    }
    
    func fetch() throws -> [BlockModel] {
        <#code#>
    }
    
    func fetch() throws -> [DailyModel] {
        <#code#>
    }
}

// MARK: - Update Method
extension CoreDataRepository {
    func update(_ mode: TimerModel) throws {
        <#code#>
    }
    
    func update(_ mode: BlockModel) throws {
        <#code#>
    }
    
    func update(_ mode: DailyModel) throws {
        <#code#>
    }
}

// MARK: - Delete Method
extension CoreDataRepository {
    func delete(_ model: TimerModel) throws {
        <#code#>
    }
    
    func delete(_ model: BlockModel) throws {
        <#code#>
    }
    
    func delete(_ model: DailyModel) throws {
        <#code#>
    }
}
