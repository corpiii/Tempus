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

    func test_TimerModel_create_is_success() {
        // Arrange
        let uuid = UUID()
        let time = 10
        let model = TimerModel(id: uuid, wasteTime: Double(time))
        
        // Act, Assert
        do {
            try repository.create(model: model)
        } catch {
            XCTFail()
        }
    }
    
    func test_DailyModel_create_is_success() {
        // Arrange
        let uuid = UUID()
        let startTime = 10
        let repeatCount = 4
        let focusTime = 12
        let breakTime = 13
        let model = DailyModel(id: uuid,
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
        let divideCount = 4
        let model = BlockModel(id: uuid, divideCount: Double(divideCount))
        
        // Act, Assert
        do {
            try repository.create(model: model)
        } catch {
            XCTFail()
        }
    }
}
