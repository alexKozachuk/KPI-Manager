//
//  Extension+Core.swift
//  KPI manager
//
//  Created by Sasha on 26/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

// MARK: - ViewController
extension UIViewController {
    static var name: String {
        return String(describing: self)
    }
    
    class func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    
    class func loadFromNib<T: UIViewController>() -> T {
        return T(nibName: String(describing: self), bundle: nil)
    }
    
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
