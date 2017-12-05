//
//  NSManagedObjectExtension.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 16.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func obtainSingleMNWithEntityName(entityName: String) -> NSManagedObject? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let count = try? self.count(for: request) else { return nil }
        if count == 1 {
            guard let entity = try? self.fetch(request) as! [NSManagedObject] else { return nil }
            return entity[0]
        } else {
            return nil
        }
    }
    
   
    
    func obtainArrayOfMNWithEntityName(entityName: String, predicate: NSPredicate?) -> [Any] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if predicate != nil {
            request.predicate = predicate
        }
 
        do {
            let array = try self.fetch(request)
            return array
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
    }
    
}
