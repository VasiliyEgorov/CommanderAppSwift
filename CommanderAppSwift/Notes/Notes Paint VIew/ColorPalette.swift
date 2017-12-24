//
//  ColorPalette.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 23.12.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

protocol ColorPaletteDelegate : class {
    func receiveColor() -> UIColor
    func receiveLineToolWidth() -> CGFloat
    func hideColorPalette()
    func showColorPalette()
}
class ColorPalette: UIImageView, ColorPaletteDelegate {
    @IBOutlet weak var tralingConstraint : NSLayoutConstraint!
    private let defaultToolWidth : CGFloat = 3.0
    private var colorPicker : UIColor!
    private var viewForIndicator : UIView!
    private var indicatorView : UIView!
    private var widthIncrement : CGFloat!
    private var availableSpace : CGFloat!
    private var estimatedPosition : CGFloat!
    private var currentWidthForLineTool : CGFloat!
    private var maxLineToolWidth : CGFloat!
    private var startOffset : CGFloat!
    private var firstTouchLocationOnSuperview : CGPoint!
    private var firstTouchLocationOnSelf : CGPoint!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = UIImage.init(named: "colorPalette.png")
        self.isUserInteractionEnabled = true
        self.currentWidthForLineTool = defaultToolWidth
    }
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentWidthForLineTool = defaultToolWidth
        if touches.count == 1 {
            guard let touch = touches.first else { return }
            self.firstTouchLocationOnSuperview = touch.location(in: self.superview)
            self.firstTouchLocationOnSelf = touch.location(in: self)
            if touch.view == self {
                self.colorPicker = recognizeColorWith(point: self.firstTouchLocationOnSelf)
                configureIndicatorViewWith(point: self.firstTouchLocationOnSuperview, color: self.colorPicker)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            guard let touch = touches.first else { return }
            let newTouchLocationOnSuperview = touch.location(in: self.superview)
            
            let deltaX = newTouchLocationOnSuperview.x - self.firstTouchLocationOnSuperview.x
            let deltaY = newTouchLocationOnSuperview.y - self.firstTouchLocationOnSuperview.y
            
            let offsetBetweenOriginXAndFinger = self.viewForIndicator.frame.origin.x + self.startOffset
            
            if self.viewForIndicator.frame.origin.x > self.estimatedPosition || newTouchLocationOnSuperview.x > offsetBetweenOriginXAndFinger {
                let newFrame = CGRect(x: self.viewForIndicator.frame.origin.x + deltaX,
                                      y: self.viewForIndicator.frame.origin.y + deltaY,
                                      width: self.viewForIndicator.frame.size.width,
                                      height: self.viewForIndicator.frame.size.height)
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.viewForIndicator.frame = newFrame
                })
                changeWidthForLineTool(originX: self.viewForIndicator.frame.origin.x)
            } else {
                let newFrame = CGRect(x: self.estimatedPosition,
                                      y: self.viewForIndicator.frame.origin.y + deltaY,
                                      width:  self.viewForIndicator.frame.size.width,
                                      height:  self.viewForIndicator.frame.size.height)
                UIView.animate(withDuration: 0.1,
                               animations: {
                                self.viewForIndicator.frame = newFrame
                })
                changeWidthForLineTool(originX: self.viewForIndicator.frame.origin.x)
            }
                let touchOnSelf = touch.location(in: self)
                let newPointForColorPicker = CGPoint(x: self.firstTouchLocationOnSelf.x, y: touchOnSelf.y)
                let checkRect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.maxX, height: self.bounds.maxY - 1)
                if checkRect.contains(newPointForColorPicker) {
                    self.colorPicker = recognizeColorWith(point: newPointForColorPicker)
                }
                updateViewForIndicatorAndIndicator(color: self.colorPicker)
                self.firstTouchLocationOnSuperview = newTouchLocationOnSuperview
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        let view = self.hitTest(point, with: event)
        if view == self {
            self.colorPicker = recognizeColorWith(point: point)
        }
        hideView(viewForIndicator: self.viewForIndicator, indicatorView: self.indicatorView, with: self.startOffset)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    // MARK: - Configuration method and Color recognizer
    private func recognizeColorWith(point : CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        self.layer.render(in: context!)
        let color = UIColor.init(red: CGFloat(pixel[0]) / 255.0,
                                green: CGFloat(pixel[1]) / 255.0,
                                blue: CGFloat(pixel[2]) / 255.0,
                                alpha: CGFloat(pixel[3]) / 255.0)
        pixel.deallocate(capacity: 4)
        return color
    }
    private func configureIndicatorViewWith(point: CGPoint, color: UIColor) {
        let width = self.superview!.bounds.size.width / 8
        let height = width
        let originX = point.x - self.bounds.size.width - width * 3
        let originY = point.y - width / 2
        self.startOffset = self.superview!.bounds.size.width - originX
        
        let newFrameViewForIndicator = CGRect(x: originX, y: originY, width: width, height: height)
        
        self.viewForIndicator = UIView.init(frame: CGRect(x: self.superview!.bounds.size.width, y: originY, width: 1.0, height: 1.0))
        self.viewForIndicator.backgroundColor = .white
        self.viewForIndicator.layer.cornerRadius = width / 2
        self.viewForIndicator.layer.masksToBounds = true
        self.viewForIndicator.layer.borderColor = color.cgColor
        self.viewForIndicator.layer.borderWidth = width / 20
        
        self.maxLineToolWidth = width - self.viewForIndicator.layer.borderWidth * 4
        
        guard let widthForIndicator = self.currentWidthForLineTool else { return }
        let heightForIndicator = widthForIndicator
        let indicatorOriginX = newFrameViewForIndicator.size.width / 2 - widthForIndicator / 2
        let indicatorOriginY = newFrameViewForIndicator.size.height / 2 - heightForIndicator / 2
        
        let newFrameIndicatorView = CGRect(x: indicatorOriginX, y: indicatorOriginY, width: widthForIndicator, height: heightForIndicator)
       
        self.indicatorView = UIView.init(frame: CGRect(x: self.viewForIndicator.frame.origin.x, y: self.viewForIndicator.frame.origin.y, width: 1.0, height: 1.0))
        self.indicatorView.layer.cornerRadius = widthForIndicator / 2
        self.indicatorView.layer.masksToBounds = true
        self.indicatorView.backgroundColor = color
        
        self.viewForIndicator.addSubview(self.indicatorView)
        self.superview?.addSubview(self.viewForIndicator)
        
        showView(viewForIndicator: self.viewForIndicator, with: newFrameViewForIndicator, and: self.indicatorView, with: newFrameIndicatorView)
        configureWidthIncrementFor(maxLineToolWidth: self.maxLineToolWidth, dependingOn: newFrameViewForIndicator.origin.x)
    }
    private func configureWidthIncrementFor(maxLineToolWidth: CGFloat, dependingOn originX: CGFloat) {
        self.availableSpace = originX
        self.widthIncrement = maxLineToolWidth / self.availableSpace
        self.estimatedPosition = self.currentWidthForLineTool / self.widthIncrement
    }
    private func changeWidthForLineTool(originX: CGFloat) {
        self.currentWidthForLineTool = (self.availableSpace - originX + self.estimatedPosition) * self.widthIncrement
        
        let newFrame = CGRect(x: self.indicatorView.frame.origin.x, y: self.indicatorView.frame.origin.y, width: self.currentWidthForLineTool, height: self.currentWidthForLineTool)
        let newCenter = CGPoint(x: self.viewForIndicator.bounds.midX, y: self.viewForIndicator.bounds.midY)
        
        self.indicatorView.frame = newFrame
        self.indicatorView.center = newCenter
        self.indicatorView.layer.cornerRadius = self.indicatorView.frame.size.width / 2
    }
    private func updateViewForIndicatorAndIndicator(color: UIColor) {
        self.viewForIndicator.layer.borderColor = color.cgColor
        self.indicatorView.backgroundColor = color
    }
    // MARK: - ColorPalette Protocol
    func receiveColor() -> UIColor {
        if self.colorPicker == nil {
            return UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        } else {
            return self.colorPicker
        }
    }
    func receiveLineToolWidth() -> CGFloat {
        return currentWidthForLineTool
    }
    func hideColorPalette() {
        self.superview?.layoutIfNeeded()
        tralingConstraint.constant = self.frame.size.width
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.superview?.layoutIfNeeded()
        })
    }
    func showColorPalette() {
        self.superview?.layoutIfNeeded()
        tralingConstraint.constant = 0
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.superview?.layoutIfNeeded()
        })
    }
    // MARK: - Animations
    private func showView(viewForIndicator: UIView, with newFrameViewForIndicator: CGRect, and indicatorView: UIView, with newFrameForIndicatorView: CGRect) {
        UIView.animate(withDuration: 0.2) {
            viewForIndicator.frame = newFrameViewForIndicator
            indicatorView.frame = newFrameForIndicatorView
        }
    }
    private func hideView(viewForIndicator: UIView, indicatorView: UIView, with startOffset: CGFloat) {
        let newFrameViewForIndicator =  CGRect(x: viewForIndicator.frame.origin.x + startOffset, y: viewForIndicator.frame.origin.y, width: 1.0, height: 1.0)
        let newFrameForIndicatorView = CGRect(x: indicatorView.frame.origin.x + startOffset, y: indicatorView.frame.origin.y, width: 0.1, height: 0.1)
        UIView.animate(withDuration: 0.2,
                       animations: {
                        viewForIndicator.frame = newFrameViewForIndicator
                        indicatorView.frame = newFrameForIndicatorView
        }) { (finished) in
            viewForIndicator.removeFromSuperview()
        }
    }
}
