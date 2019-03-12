//
//  TransitionAnimator.swift
//  LTY
//
//  Created by 花菜 on 2019/3/10.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

public class TransitionAnimator: NSObject {
    private var isPresented: Bool = false
    private let duration: TimeInterval
    init(duration: TimeInterval = 2) {
        self.duration = duration
    }
}
extension TransitionAnimator: UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    // 告诉弹出动画交给谁去处理
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    /// 该代理方法用于告诉系统谁来负责控制器如何弹出
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented {
            // 1.获取弹出的 view
            guard let presentedView = transitionContext.view(forKey: .to) else {return}
            transitionContext.containerView.addSubview(presentedView)
            // 3. 执行动画
            presentedView.alpha = 0
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                presentedView.alpha = 1
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        } else {
            guard let dismissView = transitionContext.view(forKey: .from) else {return}
            transitionContext.containerView.addSubview(dismissView)
            // 3. 执行动画
            
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                dismissView.alpha = 0
            }) { (_) in
                dismissView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
   
}
