//
//  DataManager.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

fileprivate extension Selector {
    static let contextDidSaveMainQueueContext = #selector(DataManager.contextDidSaveMainQueueContext)
    static let contextDidSavePrivateQueueContext = #selector(DataManager.contextDidSavePrivateQueueContext)
    static let managedObjectContextObjectsDidChange = #selector(DataManager.managedObjectContextObjectsDidChange)
}

extension Notification.Name {
    static let contextDidSaveMainQueueContext = Notification.Name("contextDidSaveMainQueueContext")
    static let contextDidSavePrivateQueueContext = Notification.Name("contextDidSavePrivateQueueContext")
}

final class DataManager {
    var privateQueueContext : NSManagedObjectContext
    var mainQueueContext : NSManagedObjectContext
    
    static let sharedInstance : DataManager = {
        let instance = DataManager(privateContext: NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType), mainContext: NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType))
        return instance
    }()
    private init(privateContext: NSManagedObjectContext, mainContext: NSManagedObjectContext) {
        self.mainQueueContext = mainContext
        self.privateQueueContext = privateContext
        self.mainQueueContext = persistentContainer.viewContext
        self.privateQueueContext = persistentContainer.viewContext
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveMainQueueContext(notification:)), name: .contextDidSaveMainQueueContext, object: mainQueueContext)
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSavePrivateQueueContext(notification:)), name: .contextDidSavePrivateQueueContext, object: privateQueueContext)
        NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: mainQueueContext)
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CommanderAppSwift")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
             
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: Insert counters objects
    func insertCountersMN() {
        if let _ = self.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") {
            return
        } else {
                let lifeCountersIndex = LifeCountersIndex(context: self.mainQueueContext)
                let playerMainCounters = LifeCountersMN(context: self.mainQueueContext)
                let opponentMainCounters = LifeCountersMN(context: self.mainQueueContext)
                let player = PlayerMN(context: self.mainQueueContext)
                let opponent = OpponentMN(context: self.mainQueueContext)
                let manaCounter = ManaCountersMN(context: self.mainQueueContext)
                let playerInterface = InterfaceMN(context: self.mainQueueContext)
                let opponentInterface = InterfaceMN(context: self.mainQueueContext)
                player.name = ""
                opponent.name = ""
                playerMainCounters.countersIndex = lifeCountersIndex
                player.lifeCounters = playerMainCounters
                player.manaCounter = manaCounter
                player.interface = playerInterface
                opponentMainCounters.countersIndex = lifeCountersIndex
                opponent.lifeCounters = opponentMainCounters
                opponent.interface = opponentInterface
                saveContext()
                mainQueueContext.refreshAllObjects()
        }
    }
    // MARK: - Notifications
    
    @objc func contextDidSaveMainQueueContext(notification: NSNotification) {
        self.mainQueueContext.perform {
            self.mainQueueContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    @objc func contextDidSavePrivateQueueContext(notification: NSNotification) {
        self.privateQueueContext.perform {
            self.privateQueueContext.mergeChanges(fromContextDidSave: notification as Notification)
        }
    }
    @objc func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if let _ = userInfo[NSDeletedObjectsKey] as? Set<LifeCountersMN> {
           insertCountersMN()
        }
    }
    func dealloc () {
        NotificationCenter.default.removeObserver(self)
    }
}
