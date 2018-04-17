//
//  ManaCountersHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

fileprivate enum Labels: Int {
    case First, Second, Third, Fourth, Fifth, Sixth, Seventh, Eight
}

class ManaCountersHandler: MainHandler {

    func countManawithButtonAction(tag: Int) {
        switch tag {
        case 0: manaCounters?.firstCounter = countUp(input: manaCounters?.firstCounter)
        case 1: manaCounters?.secondCounter = countUp(input: manaCounters?.secondCounter)
        case 2: manaCounters?.thirdCounter = countUp(input: manaCounters?.thirdCounter)
        case 3: manaCounters?.fourthCounter = countUp(input: manaCounters?.fourthCounter)
        case 4: manaCounters?.fifthCounter = countUp(input: manaCounters?.fifthCounter)
        case 5: manaCounters?.sixthCounter = countUp(input: manaCounters?.sixthCounter)
        case 6: manaCounters?.seventhCounter = countUp(input: manaCounters?.seventhCounter)
        case 7: manaCounters?.eighthCounter = countUp(input: manaCounters?.eighthCounter)
        case 8: manaCounters?.firstCounter = countDown(input: manaCounters?.firstCounter)
        case 9: manaCounters?.secondCounter = countDown(input: manaCounters?.secondCounter)
        case 10: manaCounters?.thirdCounter = countDown(input: manaCounters?.thirdCounter)
        case 11: manaCounters?.fourthCounter = countDown(input: manaCounters?.fourthCounter)
        case 12: manaCounters?.fifthCounter = countDown(input: manaCounters?.fifthCounter)
        case 13: manaCounters?.sixthCounter = countDown(input: manaCounters?.sixthCounter)
        case 14: manaCounters?.seventhCounter = countDown(input: manaCounters?.seventhCounter)
        case 15: manaCounters?.eighthCounter = countDown(input: manaCounters?.eighthCounter)
        default: break
        }
        manager.saveContext()
    }
    private func countUp(input: Int64?) -> Int64 {
        guard var counter = input else { return 0 }
        counter += 1
        return counter
    }
    private func countDown(input: Int64?) -> Int64 {
        guard var counter = input else { return 0 }
        if counter == 0 {
            return counter
        } else {
            counter -= 1
            return counter
        }
    }
    
    func fetchCounters(labels: [UILabel]) {
        for (index, label) in labels.enumerated() {
        let labelsEnum = Labels(rawValue:index)
            switch labelsEnum {
            case .First? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.firstCounter)
            case .Second? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.secondCounter)
            case .Third? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.thirdCounter)
            case .Fourth? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.fourthCounter)
            case .Fifth? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.fifthCounter)
            case .Sixth? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.sixthCounter)
            case .Seventh? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.seventhCounter)
            case .Eight? where index == labelsEnum?.rawValue: convertCounterIntoString(label: label, counter: manaCounters?.eighthCounter)
            default: break
            }
        }
    }
    
    private func convertCounterIntoString(label: UILabel, counter: Int64?) {
        guard let counter = counter else { return }
        label.text = String(counter)
        
    }
    
    func resetCounters() {
        
        if let mana = manaCounters {
        manager.mainQueueContext.delete(mana)
        manager.saveContext()
        let newCounter = ManaCountersMN(context: manager.mainQueueContext)
        playerCounter?.manaCounter = newCounter
        manager.saveContext()
        }
    }
}
