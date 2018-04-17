//
//  CountersHandler.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 12.04.2018.
//  Copyright © 2018 VasiliyEgorov. All rights reserved.
//

import UIKit

fileprivate enum ButtonsImage: Int {
    case SecondRowImage = 0
    case ThirdRowImage = 1
}

fileprivate enum GeneralTax: Int {
    case TaxOne
    case TaxTwo
}
class CountersHandler: MainHandler {
    
    private let caretUp = UIImage.init(named: "caret-up.png")
    private let caretDown = UIImage.init(named: "caret-down.png")
    
    func count(tag: Int) {
        switch screenType {
            case .Player? where tag == 0: playerCounter?.lifeCounters?.firstCounter = countUp(input: playerCounter?.lifeCounters?.firstCounter)
            case .Player? where tag == 1: playerCounter?.lifeCounters?.secondCounter = countUp(input: playerCounter?.lifeCounters?.secondCounter)
            case .Player? where tag == 2: playerCounter?.lifeCounters?.thirdCounter = countUp(input: playerCounter?.lifeCounters?.thirdCounter)
            case .Player? where tag == 3: playerCounter?.lifeCounters?.fourthCounter = countUp(input: playerCounter?.lifeCounters?.fourthCounter)
            case .Player? where tag == 4: playerCounter?.lifeCounters?.firstCounter = countDown(input: playerCounter?.lifeCounters?.firstCounter)
            case .Player? where tag == 5: playerCounter?.lifeCounters?.secondCounter = countDown(input: playerCounter?.lifeCounters?.secondCounter)
            case .Player? where tag == 6: playerCounter?.lifeCounters?.thirdCounter = countDown(input: playerCounter?.lifeCounters?.thirdCounter)
            case .Player? where tag == 7: playerCounter?.lifeCounters?.fourthCounter = countDown(input: playerCounter?.lifeCounters?.fourthCounter)
            case .Opponent? where tag == 0: opponentCounter?.lifeCounters?.firstCounter = countUp(input: opponentCounter?.lifeCounters?.firstCounter)
            case .Opponent? where tag == 1: opponentCounter?.lifeCounters?.secondCounter = countUp(input: opponentCounter?.lifeCounters?.secondCounter)
            case .Opponent? where tag == 2: opponentCounter?.lifeCounters?.thirdCounter = countUp(input: opponentCounter?.lifeCounters?.thirdCounter)
            case .Opponent? where tag == 3: opponentCounter?.lifeCounters?.fourthCounter = countUp(input: opponentCounter?.lifeCounters?.fourthCounter)
            case .Opponent? where tag == 4: opponentCounter?.lifeCounters?.firstCounter = countDown(input: opponentCounter?.lifeCounters?.firstCounter)
            case .Opponent? where tag == 5: opponentCounter?.lifeCounters?.secondCounter = countDown(input: opponentCounter?.lifeCounters?.secondCounter)
            case .Opponent? where tag == 6: opponentCounter?.lifeCounters?.thirdCounter = countDown(input: opponentCounter?.lifeCounters?.thirdCounter)
            case .Opponent? where tag == 7: opponentCounter?.lifeCounters?.fourthCounter = countDown(input: opponentCounter?.lifeCounters?.fourthCounter)
            case .none: return
            case .some(_): return
            
        }
    }
    func updateLabels(labels: [UILabel]) {
        for (index, label) in labels.enumerated() {
            switch screenType {
                case .Player? where index == 0: convertCounterIntoString(label: label, counter: playerCounter?.lifeCounters?.firstCounter)
                case .Player? where index == 0: convertCounterIntoString(label: label, counter: playerCounter?.lifeCounters?.secondCounter)
                case .Player? where index == 0: convertCounterIntoString(label: label, counter: playerCounter?.lifeCounters?.thirdCounter)
                case .Player? where index == 0: convertCounterIntoString(label: label, counter: playerCounter?.lifeCounters?.fourthCounter)
                case .Opponent? where index == 0: convertCounterIntoString(label: label, counter: opponentCounter?.lifeCounters?.firstCounter)
                case .Opponent? where index == 0: convertCounterIntoString(label: label, counter: opponentCounter?.lifeCounters?.secondCounter)
                case .Opponent? where index == 0: convertCounterIntoString(label: label, counter: opponentCounter?.lifeCounters?.thirdCounter)
                case .Opponent? where index == 0: convertCounterIntoString(label: label, counter: opponentCounter?.lifeCounters?.fourthCounter)
            default: break
        }
        }
    }
    
    func updateButtonImages(button: UIButton) {
        let images = ButtonsImage(rawValue: button.tag)
        
        switch images {
            case .SecondRowImage?: button.setBackgroundImage(setCurrentRowImg(type: screenType, isHidden: isHiddenSecondRow), for: .normal)
            case .ThirdRowImage?: button.setBackgroundImage(setCurrentRowImg(type: screenType, isHidden: isHiddenThirdRow), for: .normal)
            case .none: return
        }
    }
    func resetCounters() {
        switch screenType {
        case .Player?:
            playerCounter?.lifeCounters?.firstCounter = 0
            playerCounter?.lifeCounters?.secondCounter = 0
            playerCounter?.lifeCounters?.thirdCounter = 0
            playerCounter?.lifeCounters?.fourthCounter = 0
        case .Opponent?:
            opponentCounter?.lifeCounters?.firstCounter = 0
            opponentCounter?.lifeCounters?.secondCounter = 0
            opponentCounter?.lifeCounters?.thirdCounter = 0
            opponentCounter?.lifeCounters?.fourthCounter = 0
        default: return
        }
    }
    
    func setCountersName(txtField: UITextField) {
        let tax = GeneralTax(rawValue: txtField.tag)
        let type = (screenType, tax)
        switch type {
            case (.Player?, .TaxOne?): playerCounter?.thirdCounterName = txtField.text
            case (.Player?, .TaxTwo?): playerCounter?.fourthCounterName = txtField.text
            case (.Opponent?, .TaxOne?): opponentCounter?.thirdCounterName = txtField.text
            case (.Opponent?, .TaxTwo?): opponentCounter?.fourthCounterName = txtField.text
        default: return
        }
    }
    
    func getCountersName(txtFields: [UITextField]) {
        for (index, txtField) in txtFields.enumerated() {
            let tax = GeneralTax(rawValue: index)
            let type = (screenType, tax)
            switch type {
                case (.Player?, .TaxOne?): txtField.text = playerCounter?.thirdCounterName
                case (.Player?, .TaxTwo?): txtField.text = playerCounter?.fourthCounterName
                case (.Opponent?, .TaxOne?): txtField.text = opponentCounter?.thirdCounterName
                case (.Opponent?, .TaxTwo?): txtField.text = opponentCounter?.fourthCounterName
                default: break
            }
        }
    }
    // MARK: - Private
    
    private func convertCounterIntoString(label: UILabel, counter: Int64?) {
        guard let counter = counter else { return }
        label.text = String(counter)
    }
    private func setCurrentRowImg(type: IndexEnum?, isHidden: Bool?) -> UIImage? {
        let newType = (type, isHidden)
        switch newType {
        case (.Player?, isHidden): return caretDown
        case (.Player?, isHidden == false): return caretUp
        case (.Opponent?, isHidden): return caretDown
        case (.Opponent?, isHidden == false): return caretUp
        default:return nil
        }
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
}
