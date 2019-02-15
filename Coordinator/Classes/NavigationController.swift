//
//  NavigationController.swift
//  RxToolkit
//
//  Created by Martin Daum on 15.02.19.
//

import UIKit

open class NavigationController: UINavigationController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return topViewController?.modalPresentationStyle ?? super.modalPresentationStyle
        }
        set {
            super.modalPresentationStyle = newValue
        }
    }
    
    override open var modalTransitionStyle: UIModalTransitionStyle {
        get {
            return topViewController?.modalTransitionStyle ?? super.modalTransitionStyle
        }
        set {
            super.modalTransitionStyle = newValue
        }
    }
    
    override open var transitioningDelegate: UIViewControllerTransitioningDelegate? {
        get {
            return topViewController?.transitioningDelegate ?? super.transitioningDelegate
        }
        set {
            super.transitioningDelegate = newValue
        }
    }
}
