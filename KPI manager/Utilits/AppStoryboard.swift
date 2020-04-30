//
//  AppStoryboard.swift
//  KPI manager
//
//  Created by Sasha on 26/04/2020.
//  Copyright © 2020 Sasha. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue.capitalized, bundle: nil)
    }
    
    var rootViewController: UIViewController {
        switch self {
            case .main: return MainVC.instantiate(from: self)
        }
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = viewControllerClass.name
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}
