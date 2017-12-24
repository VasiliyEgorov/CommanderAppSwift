//
//  DoodleView.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class DoodleView: UIView {
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    private var path : UIBezierPath!
    private var colorsArray : Array<UIColor>!
    private var touchLocation : CGPoint!
    var pathsArray : Array<UIBezierPath>!
    weak var delegate : ColorPaletteDelegate?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.colorsArray = Array()
        self.pathsArray = Array()
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
    }
  
     override func draw(_ rect: CGRect) {
      var i = 0
        for paths in self.pathsArray {
            let color = self.colorsArray[i]
            i += 1
            color.setStroke()
            paths.stroke(with: .normal, alpha: 1.0)
            paths.stroke()
        }
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        addLayerTo(button: undoButton)
        addLayerTo(button: resetButton)
        undoButton.setTitle("Undo", for: .normal)
        resetButton.setTitle("Reset", for: .normal)
    }
    // MARK: - Buttons
    private func addLayerTo(button: UIButton) {
        let borderLayer = CAShapeLayer.init()
        borderLayer.backgroundColor = UIColor.white.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1)
        button.layer.addSublayer(borderLayer)
    }
    // MARK: - ColorPalette Protocol
    
    private func enableOrDisableButtons() {
        if self.pathsArray.count == 0 {
            self.undoButton.isEnabled = false
            self.resetButton.isEnabled = false
        } else {
            self.undoButton.isEnabled = true
            self.resetButton.isEnabled = true
        }
    }
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchOnSelf = touch?.location(in: self)
        let view = self.hitTest(touchOnSelf ?? CGPoint.zero, with: event)
        
        if view == self {
            self.delegate?.hideColorPalette()
            self.path = UIBezierPath()
            self.path.lineWidth = self.delegate?.receiveLineToolWidth() ?? 3
            self.path.lineJoinStyle = .round
            self.path.lineCapStyle = .round
            let touch = touches.first
            self.path.move(to: touch?.location(in: self) ?? CGPoint.zero)
            self.pathsArray.append(self.path)
            self.colorsArray.append(self.delegate?.receiveColor() ?? .black)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchOnSelf = touch?.location(in: self)
        let view = self.hitTest(touchOnSelf ?? CGPoint.zero, with: event)
        
        if view == self {
            if self.path == nil {
                self.touchesBegan(touches, with: event)
            }
            self.path.addLine(to: touch?.location(in: self) ?? CGPoint.zero)
            self.setNeedsDisplay()
        } else {
            self.path = nil
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchOnSelf = touch?.location(in: self)
        let view = self.hitTest(touchOnSelf ?? CGPoint.zero, with: event)
        
        if view == self {
            self.path.addLine(to: touch?.location(in: self) ?? CGPoint.zero)
            self.setNeedsDisplay()
        }
        enableOrDisableButtons()
        self.delegate?.showColorPalette()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
    // MARK: - Buttons action
   @IBAction func undoButtonAction(_ sender: UIButton) {
        self.pathsArray.removeLast()
        self.colorsArray.removeLast()
        self.setNeedsDisplay()
        enableOrDisableButtons()
    }
    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.pathsArray.removeAll()
        self.colorsArray.removeAll()
        self.setNeedsDisplay()
        enableOrDisableButtons()
    }
}
