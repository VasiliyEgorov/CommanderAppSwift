//
//  MenuVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class MenuViewModel {
    private unowned let manager = DataManager.sharedInstance
    private var lifeCountersIndex : LifeCountersIndex {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "LifeCountersIndex") as! LifeCountersIndex
    }
    let cellsText = ["Card search", "Roll a die", "Heads or tails", "Reset all counters"]
    
    func resetCountersAlert(present:(UIAlertController) -> Void, complition:@escaping () -> Void) {
        let message = NSLocalizedString("All counters will be reset include avatars, names and counter names",
                                        comment: "Alert message when the user has taped resetCounters button")
        let alertController = UIAlertController.init(title: "CommanderApp", message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction.init(title: NSLocalizedString("Reset", comment: "Alert Reset button"), style: .default, handler: { (action) in
            self.manager.mainQueueContext.delete(self.lifeCountersIndex)
            self.manager.saveContext()
            self.manager.insertCountersMN()
            complition()
        })
        alertController.addAction(resetAction)
        let cancelAction = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController)
    }
}
