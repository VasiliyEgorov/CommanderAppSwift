//
//  ManaCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 20.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import CoreData

class ManaCounterVM {
    
    private unowned let manager = DataManager.sharedInstance
    private var manaCounters : ManaCountersMN {
        return manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "ManaCountersMN") as! ManaCountersMN
    }
    
    func countManawithButtonAction(tag: Int) {
        switch tag {
        case 0: countUp(counter: &manaCounters.firstCounter, observable: &observableFirstCounter.value)
        case 1: countUp(counter: &manaCounters.secondCounter, observable: &observableSecondCounter.value)
        case 2: countUp(counter: &manaCounters.thirdCounter, observable: &observableThirdCounter.value)
        case 3: countUp(counter: &manaCounters.fourthCounter, observable: &observableFourthCounter.value)
        case 4: countUp(counter: &manaCounters.fifthCounter, observable: &observableFifthCounter.value)
        case 5: countUp(counter: &manaCounters.sixthCounter, observable: &observableSixthCounter.value)
        case 6: countUp(counter: &manaCounters.seventhCounter, observable: &observableSeventhCounter.value)
        case 7: countUp(counter: &manaCounters.eighthCounter, observable: &observableEighthCounter.value)
        case 8: countDown(counter: &manaCounters.firstCounter, observable: &observableFirstCounter.value)
        case 9: countDown(counter: &manaCounters.secondCounter, observable: &observableSecondCounter.value)
        case 10: countDown(counter: &manaCounters.thirdCounter, observable: &observableThirdCounter.value)
        case 11: countDown(counter: &manaCounters.fourthCounter, observable: &observableFourthCounter.value)
        case 12: countDown(counter: &manaCounters.fifthCounter, observable: &observableFifthCounter.value)
        case 13: countDown(counter: &manaCounters.sixthCounter, observable: &observableSixthCounter.value)
        case 14: countDown(counter: &manaCounters.seventhCounter, observable: &observableSeventhCounter.value)
        case 15: countDown(counter: &manaCounters.eighthCounter, observable: &observableEighthCounter.value)
        default: break
        }
        manager.saveContext()
    }
    private func countUp(counter: inout Int64, observable: inout Int64) {
        counter += 1
        observable = counter
    }
    private func countDown(counter: inout Int64, observable: inout Int64) {
        if counter == 0 {
            return
        } else {
            counter -= 1
            observable = counter
        }
    }
    func resetCounters() {
        let player = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "PlayerMN") as! PlayerMN
        manager.mainQueueContext.delete(manaCounters)
        manager.saveContext()
        let newCounter = ManaCountersMN(context: manager.mainQueueContext)
        player.manaCounter = newCounter
        manager.saveContext()
    }
    
    // MARK: - Observing
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
       
        if let _ = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            observableFirstCounter.value = 0
            observableSecondCounter.value = 0
            observableThirdCounter.value = 0
            observableFourthCounter.value = 0
            observableFifthCounter.value = 0
            observableSixthCounter.value = 0
            observableSeventhCounter.value = 0
            observableEighthCounter.value = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    var observableFirstCounter : Observable<Int64>!
    var observableSecondCounter : Observable<Int64>!
    var observableThirdCounter : Observable<Int64>!
    var observableFourthCounter : Observable<Int64>!
    var observableFifthCounter : Observable<Int64>!
    var observableSixthCounter : Observable<Int64>!
    var observableSeventhCounter : Observable<Int64>!
    var observableEighthCounter : Observable<Int64>!
    init () {
        observableFirstCounter = Observable(manaCounters.firstCounter)
        observableSecondCounter = Observable(manaCounters.secondCounter)
        observableThirdCounter = Observable(manaCounters.thirdCounter)
        observableFourthCounter = Observable(manaCounters.fourthCounter)
        observableFifthCounter = Observable(manaCounters.fifthCounter)
        observableSixthCounter = Observable(manaCounters.sixthCounter)
        observableSeventhCounter = Observable(manaCounters.seventhCounter)
        observableEighthCounter = Observable(manaCounters.eighthCounter)
         NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange(notification:)), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: manager.mainQueueContext)
    }
}
