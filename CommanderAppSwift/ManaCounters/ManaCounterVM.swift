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

class ManaCounterVM {
    
    private unowned let manager = DataManager.sharedInstance
    private let manaCounters : ManaCountersMN!
    
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
        manaCounters.firstCounter = 0
        observableFirstCounter.value = manaCounters.firstCounter
        manaCounters.secondCounter = 0
        observableSecondCounter.value = manaCounters.secondCounter
        manaCounters.thirdCounter = 0
        observableThirdCounter.value = manaCounters.thirdCounter
        manaCounters.fourthCounter = 0
        observableFourthCounter.value = manaCounters.fourthCounter
        manaCounters.fifthCounter = 0
        observableFifthCounter.value = manaCounters.fifthCounter
        manaCounters.sixthCounter = 0
        observableSixthCounter.value = manaCounters.sixthCounter
        manaCounters.seventhCounter = 0
        observableSeventhCounter.value = manaCounters.seventhCounter
        manaCounters.eighthCounter = 0
        observableEighthCounter.value = manaCounters.eighthCounter
        manager.saveContext()
    }
    let observableFirstCounter : Observable<Int64>!
    let observableSecondCounter : Observable<Int64>!
    let observableThirdCounter : Observable<Int64>!
    let observableFourthCounter : Observable<Int64>!
    let observableFifthCounter : Observable<Int64>!
    let observableSixthCounter : Observable<Int64>!
    let observableSeventhCounter : Observable<Int64>!
    let observableEighthCounter : Observable<Int64>!
    init () {
        manaCounters = manager.mainQueueContext.obtainSingleMNWithEntityName(entityName: "ManaCountersMN") as! ManaCountersMN
        observableFirstCounter = Observable(manaCounters.firstCounter)
        observableSecondCounter = Observable(manaCounters.secondCounter)
        observableThirdCounter = Observable(manaCounters.thirdCounter)
        observableFourthCounter = Observable(manaCounters.fourthCounter)
        observableFifthCounter = Observable(manaCounters.fifthCounter)
        observableSixthCounter = Observable(manaCounters.sixthCounter)
        observableSeventhCounter = Observable(manaCounters.seventhCounter)
        observableEighthCounter = Observable(manaCounters.eighthCounter)
    }
}
