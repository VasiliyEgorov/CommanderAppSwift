//
//  ManaCounterVM.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 20.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import Foundation



struct ManaCounterVM {
    
    private let model = ManaCounterM()
    var firstCounter : Int64 {
        get {
        return model.manaCounters.firstCounter
        } set {
            model.manaCounters.firstCounter = firstCounter
        }
    }
    var secondCounter : Int64 {
        get {
        return model.manaCounters.secondCounter
        } set {
            model.manaCounters.secondCounter = secondCounter
        }
    }
    var thirdCounter : Int64 {
        get {
        return model.manaCounters.thirdCounter
        } set {
            model.manaCounters.thirdCounter = thirdCounter
        }
    }
    var fourthCounter : Int64 {
        get {
        return model.manaCounters.fourthCounter
        } set {
            model.manaCounters.fourthCounter = fourthCounter
        }
    }
    var fifthCounter : Int64 {
        get {
        return model.manaCounters.fifthCounter
        } set {
              model.manaCounters.fifthCounter = fifthCounter
            }
    }
    var sixthCounter : Int64 {
        get {
        return model.manaCounters.sixthCounter
        } set {
            model.manaCounters.sixthCounter = sixthCounter
        }
    }
    var seventhCounter : Int64 {
        get {
        return model.manaCounters.seventhCounter
        } set {
            model.manaCounters.seventhCounter = seventhCounter
        }
    }
    var eighthCounter : Int64 {
        get {
        return model.manaCounters.eighthCounter
        } set {
            model.manaCounters.eighthCounter = eighthCounter
        }
    }
    mutating func countManawithButtonAction(tag: Int) {
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
        DataManager.sharedInstance.saveContext()
    }
    private func countDown(counter: inout Int64) {
        if counter == 0 {
            return
        } else {
            counter -= 0
            DataManager.sharedInstance.saveContext()
        }
    }
}
