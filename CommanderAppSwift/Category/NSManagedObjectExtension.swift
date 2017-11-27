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
    
    func obtainSingleMNWithEntityName(entityName: String) -> Any? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
   
        var result : Any?
        do {
            result = try self.fetch(request).last
            
        }  catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
            
        }
        return result
    }
    
   
    
    func obtainArrayOfMNWithEntityName(entityName: String, predicate: NSPredicate?) -> [Any?] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if predicate != nil {
            request.predicate = predicate
        }
 
        var array : [Any] = Array()
        do {
             array = try self.fetch(request)
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return array
    }
    
}
