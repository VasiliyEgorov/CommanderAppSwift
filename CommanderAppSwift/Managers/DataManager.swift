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
}

extension Notification.Name {
    static let contextDidSaveMainQueueContext = Notification.Name("contextDidSaveMainQueueContext")
    static let contextDidSavePrivateQueueContext = Notification.Name("contextDidSavePrivateQueueContext")
}

final class DataManager {
    let privateQueueContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
    let mainQueueContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    static let sharedInstance = DataManager()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveMainQueueContext(notification:)), name: .contextDidSaveMainQueueContext, object: mainQueueContext)
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSavePrivateQueueContext(notification:)), name: .contextDidSavePrivateQueueContext, object: privateQueueContext)
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
    func dealloc () {
        NotificationCenter.default.removeObserver(self)
    }
}
