//
//  MenuHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 17.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

class MenuHandler: MainHandler {
    
    func resetCountersAlert(present:(UIAlertController) -> Void, complition:@escaping () -> Void) {
        let message = NSLocalizedString("All counters will be reset include avatars, names and counter names",
                                        comment: "Alert message when the user has taped resetCounters button")
        let alertController = UIAlertController.init(title: "CommanderApp", message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction.init(title: NSLocalizedString("Reset", comment: "Alert Reset button"), style: .default, handler: { (action) in
            guard let lifeCountersIndex = self.lifeCountersIndex else { complition(); return }
            self.manager.mainQueueContext.delete(lifeCountersIndex)
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
