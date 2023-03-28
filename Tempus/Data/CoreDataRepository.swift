//
//  CoreDataRepository.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import CoreData
import Foundation

class CoreDataRepository: DataManagerRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

// MARK: - Create Method
extension CoreDataRepository {
    func create(mode: TimerModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "TimerEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.wasteTime, forKey: "wasteTime")
        newObject.setValue(Date(), forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            throw DataManageError.createFailure
        }
    }
    
    func create(mode: BlockModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BlockEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.divideCount, forKey: "divideCount")
        newObject.setValue(Date(), forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            throw DataManageError.createFailure
        }
    }
    
    func create(mode: DailyModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DailyEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(mode.id, forKey: "uuid")
        newObject.setValue(mode.startTime, forKey: "startTime")
        newObject.setValue(mode.repeatCount, forKey: "repeatCount")
        newObject.setValue(mode.focusTime, forKey: "focusTime")
        newObject.setValue(mode.breakTime, forKey: "breakTime")
        newObject.setValue(Date(), forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            throw DataManageError.createFailure
        }
    }
}

// MARK: - Fetch Method
extension CoreDataRepository {
    func fetch() throws -> [TimerEntity] {
        let context = container.viewContext
        let fetchRequest = TimerEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest) as [TimerEntity]
            return result
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.fetchFailure
        }
    }
    
    func fetch() throws -> [BlockEntity] {
        let context = container.viewContext
        let fetchRequest = BlockEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest) as [BlockEntity]
            return result
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.fetchFailure
        }
    }
    
    func fetch() throws -> [DailyEntity] {
        let context = container.viewContext
        let fetchRequest = DailyEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest) as [DailyEntity]
            return result
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.fetchFailure
        }
    }
}

// MARK: - Update Method
extension CoreDataRepository {
    func update(_ mode: TimerModel) throws {
        let context = container.viewContext
        let fetchRequest = TimerEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", mode.id as CVarArg)
        
        do {
            guard let result = try context.fetch(fetchRequest) as [TimerEntity],
                  let foundedObject = result[0] else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(mode.wasteTime, forKey: "wasteTime")
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.updateFailure
        }
    }
    
    func update(_ mode: BlockModel) throws {
        let context = container.viewContext
        let fetchRequest = BlockEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", mode.id as CVarArg)
        
        do {
            guard let result = try context.fetch(fetchRequest) as [BlockEntity],
                  let foundedObject = result[0] else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(mode.divideCount, forKey: "divideCount")
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.updateFailure
        }
    }
    
    func update(_ mode: DailyModel) throws {
        let context = container.viewContext
        let fetchRequest = DailyEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", mode.id as CVarArg)
        
        do {
            guard let result = try context.fetch(fetchRequest) as [TimerEntity],
                  let foundedObject = result[0] else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(mode.startTime, forKey: "startTime")
            foundedObject.setValue(mode.repeatCount, forKey: "repeatCount")
            foundedObject.setValue(mode.focusTime, forKey: "focusTime")
            foundedObject.setValue(mode.breakTime, forKey: "breakTime")
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.updateFailure
        }
    }
}

// MARK: - Delete Method
extension CoreDataRepository {
    func delete(_ model: TimerModel) throws {
        
    }
    
    func delete(_ model: BlockModel) throws {
        
    }
    
    func delete(_ model: DailyModel) throws {
        
    }
}
