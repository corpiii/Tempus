//
//  CoreDataRepositoryTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/03/29.
//

import CoreData
import XCTest

final class CoreDataRepositoryTests: XCTestCase {
    var persistentContainer: NSPersistentContainer!
    var repository: CoreDataRepository!
    
    override func setUpWithError() throws {
        persistentContainer = NSPersistentContainer(name: "Tempus")
        persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load test store: \(error.localizedDescription)")
            }
        }
        
        repository = CoreDataRepository(container: persistentContainer)
    }

    override func tearDownWithError() throws {
        persistentContainer.viewContext.reset()
    }
}

// MARK: - Create Test
extension CoreDataRepositoryTests {
    func test_TimerModel_create_is_success() {
        // Arrange
        let uuid = UUID()
        let time = 10
        let title = "testTitle"
        let context = persistentContainer.viewContext
        // Act, Assert
        do {
            let entity = NSEntityDescription.entity(forEntityName: "TimerEntity", in: context)
            let object = NSManagedObject(entity: entity!, insertInto: context)
            
            object.setValue(uuid, forKey: "uuid")
            object.setValue(time, forKey: "wasteTime")
            object.setValue(title, forKey: "title")
            object.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
            
            try context.save()
            
            let request = TimerEntity.fetchRequest()
            let result = try context.fetch(request)
            
            for i in result {
                print(i.uuid)
            }
            print(uuid)
        } catch {
            XCTFail()
        }
    }
    
    func test_DailyModel_create_is_success() {
        // Arrange
        let uuid = UUID()
        let testTitle = "testTitle"
        let startTime = 10
        let repeatCount = 4
        let focusTime = 12
        let breakTime = 13
        
        let model = DailyModel(id: uuid,
                               title: testTitle,
                               startTime: Double(startTime),
                               repeatCount: repeatCount,
                               focusTime: Double(focusTime),
                               breakTime: Double(breakTime))
        
        // Act, Assert
        do {
            try repository.create(model: model)
        } catch {
            XCTFail()
        }
    }
    
    func test_BlockModel_create_is_success() {
        // Arrange
        let uuid = UUID()
        let testTitle = "testTitle"
        let divideCount = 4
        let model = BlockModel(id: uuid, title: testTitle, divideCount: Double(divideCount))
        
        // Act, Assert
        do {
            try repository.create(model: model)
        } catch {
            XCTFail()
        }
    }
}

// MARK: - Fetch Test
extension CoreDataRepositoryTests {
    func test_TimerModel_fetch_is_success() {
        // Arrange
        let uuid = UUID()
        let testTitle = "testTitle"
        let time = 10
        let model = TimerModel(id: uuid, title: testTitle, wasteTime: Double(time))
        
        try! repository.create(model: model)
        
        // Act, Assert
        do {
            let result = try repository.fetchAllTimerEntity()
            let object = result.first!
            
            XCTAssertEqual(uuid, object.uuid)
        } catch {
            XCTFail()
        }
    }
    
    func test_DailyModel_fetch_is_success() {
        
    }
    
    func test_BlockModel_fetch_is_success() {
        
    }
}

// MARK: - Update Test
extension CoreDataRepositoryTests {
    
}

// MARK: - Delete Test
extension CoreDataRepositoryTests {
    
}
