//
//  ManaCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 20.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation



class ManaCounterVM {
    
    private let manager = DataManager.sharedInstance
    private var manaCounters : ManaCountersMN {
        get {
            let mana = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "ManaCountersMN")
            return mana as! ManaCountersMN
        }
    }
    var firstCounter : Int64 {
        get {
        return manaCounters.firstCounter
        } set {
            manaCounters.firstCounter = newValue
            manager.saveContext()
        }
    }
    var secondCounter : Int64 {
        get {
        return manaCounters.secondCounter
        } set {
            manaCounters.secondCounter = newValue
            manager.saveContext()
        }
    }
    var thirdCounter : Int64 {
        get {
        return manaCounters.thirdCounter
        } set {
            manaCounters.thirdCounter = newValue
            manager.saveContext()
        }
    }
    var fourthCounter : Int64 {
        get {
        return manaCounters.fourthCounter
        } set {
            manaCounters.fourthCounter = newValue
            manager.saveContext()
        }
    }
    var fifthCounter : Int64 {
        get {
        return manaCounters.fifthCounter
        } set {
              manaCounters.fifthCounter = newValue
            manager.saveContext()
            }
    }
    var sixthCounter : Int64 {
        get {
        return manaCounters.sixthCounter
        } set {
            manaCounters.sixthCounter = newValue
            manager.saveContext()
        }
    }
    var seventhCounter : Int64 {
        get {
        return manaCounters.seventhCounter
        } set {
            manaCounters.seventhCounter = newValue
            manager.saveContext()
        }
    }
    var eighthCounter : Int64 {
        get {
        return manaCounters.eighthCounter
        } set {
            manaCounters.eighthCounter = newValue
            manager.saveContext()
        }
    }
    func countManawithButtonAction(tag: Int) {
        switch tag {
        case 0: countUp(counter: &firstCounter)
        case 1: countUp(counter: &secondCounter)
        case 2: countUp(counter: &thirdCounter)
        case 3: countUp(counter: &fourthCounter)
        case 4: countUp(counter: &fifthCounter)
        case 5: countUp(counter: &sixthCounter)
        case 6: countUp(counter: &seventhCounter)
        case 7: countUp(counter: &eighthCounter)
        case 8: countDown(counter: &firstCounter)
        case 9: countDown(counter: &secondCounter)
        case 10: countDown(counter: &thirdCounter)
        case 11: countDown(counter: &fourthCounter)
        case 12: countDown(counter: &fifthCounter)
        case 13: countDown(counter: &sixthCounter)
        case 14: countDown(counter: &seventhCounter)
        case 15: countDown(counter: &eighthCounter)
        default: break
          
        }
    }
    private func countUp(counter: inout Int64) {
        counter += 1
    }
    private func countDown(counter: inout Int64) {
        if counter == 0 {
            return
        } else {
            counter -= 1
        }
    }
    func resetCounters() {
        self.firstCounter = 0
        self.secondCounter = 0
        self.thirdCounter = 0
        self.fourthCounter = 0
        self.fifthCounter = 0
        self.sixthCounter = 0
        self.seventhCounter = 0
        self.eighthCounter = 0
    }
}
