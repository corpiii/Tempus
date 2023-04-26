//
//  CoreDataRepository.swift
//  Tempus
//
//  Created by 이정민 on 2023/03/29.
//

import CoreData

final class CoreDataRepository: DataManagerRepository {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

// MARK: - Create Method
extension CoreDataRepository {
    func create(_ model: TimerModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "TimerEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(model.id, forKey: "uuid")
        newObject.setValue(model.wasteTime, forKey: "wasteTime")
        newObject.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            throw DataManageError.createFailure
        }
    }
    
    func create(_ model: BlockModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "BlockEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(model.id, forKey: "uuid")
        newObject.setValue(model.divideCount, forKey: "divideCount")
        newObject.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif
            
            throw DataManageError.createFailure
        }
    }
    
    func create(_ model: DailyModel) throws {
        let context = container.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "DailyEntity",
                                                      in: context) else {
            throw DataManageError.createFailure
        }
        
        let newObject = NSManagedObject(entity: entity, insertInto: context)
        
        newObject.setValue(model.id, forKey: "uuid")
        newObject.setValue(model.startTime, forKey: "startTime")
        newObject.setValue(model.repeatCount, forKey: "repeatCount")
        newObject.setValue(model.focusTime, forKey: "focusTime")
        newObject.setValue(model.breakTime, forKey: "breakTime")
        newObject.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
        
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
    func fetchAllTimerModel() throws -> [TimerModel] {
        let context = container.viewContext
        let fetchRequest = TimerEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map { entity in
                entity.toModel
            }
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.fetchFailure
        }
    }
    
    func fetchAllBlockModel() throws -> [BlockModel] {
        let context = container.viewContext
        let fetchRequest = BlockEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest) as [BlockEntity]
            return result.map { entity in
                entity.toModel
            }
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.fetchFailure
        }
    }
    
    func fetchAllDailyModel() throws -> [DailyModel] {
        let context = container.viewContext
        let fetchRequest = DailyEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let result = try context.fetch(fetchRequest) as [DailyEntity]
            return result.map { entity in
                entity.toModel
            }
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
    func update(_ model: TimerModel) throws {
        let context = container.viewContext
        let fetchRequest = TimerEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(model.wasteTime, forKey: "wasteTime")
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.updateFailure
        }
    }
    
    func update(_ model: BlockModel) throws {
        let context = container.viewContext
        let fetchRequest = BlockEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(model.divideCount, forKey: "divideCount")
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.updateFailure
        }
    }
    
    func update(_ model: DailyModel) throws {
        let context = container.viewContext
        let fetchRequest = DailyEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.updateFailure
            }
            
            foundedObject.setValue(model.startTime, forKey: "startTime")
            foundedObject.setValue(model.repeatCount, forKey: "repeatCount")
            foundedObject.setValue(model.focusTime, forKey: "focusTime")
            foundedObject.setValue(model.breakTime, forKey: "breakTime")
            
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
        let context = container.viewContext
        let fetchRequest = TimerEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.deleteFailure
            }
            
            context.delete(foundedObject)
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.deleteFailure
        }
    }
    
    func delete(_ model: BlockModel) throws {
        let context = container.viewContext
        let fetchRequest = BlockEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.deleteFailure
            }
            
            context.delete(foundedObject)
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.deleteFailure
        }
    }
    
    func delete(_ model: DailyModel) throws {
        let context = container.viewContext
        let fetchRequest = DailyEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", model.id as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            guard let foundedObject = result.first else {
                throw DataManageError.deleteFailure
            }
            
            context.delete(foundedObject)
            
            try context.save()
        } catch {
            #if DEBUG
            print(error)
            #endif

            throw DataManageError.deleteFailure
        }
    }
}
