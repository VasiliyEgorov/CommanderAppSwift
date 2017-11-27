//
//  TabBarSwitchAnimations.swift
//  CommanderAppSwift
//
//  Created by Vasiliy Egorov on 27.11.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

import UIKit

class TabBarSwitchAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    static let duration = 0.15
    private var fromIndex : Int
    private var toIndex : Int
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TabBarSwitchAnimation.duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        let fromView = fromVC!.view
        let toView = toVC!.view
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        var newFrame : CGRect
        var frameAfterAnimation : CGRect
        
        if toIndex < fromIndex {
            
            toView!.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            newFrame = toView!.frame
            frameAfterAnimation = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction],
                           animations: {
                            newFrame.origin.x += newFrame.size.width
                            toView?.frame = newFrame
            }, completion: { (finished) in
                toView?.frame = frameAfterAnimation
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        } else {
            toView!.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            newFrame = toView!.frame
            frameAfterAnimation = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction],
                           animations: {
                            newFrame.origin.x = 0
                            toView?.frame = newFrame
            }, completion: { (finished) in
                toView?.frame = frameAfterAnimation
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    required init(fromIndex: Int, toIndex: Int) {
        self.fromIndex = fromIndex
        self.toIndex = toIndex
    }
}
