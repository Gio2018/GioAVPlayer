//
//  UIPresentationController+Utility.swift
//  GioAVPlayer
//
//  Created by Giorgio Ruscigno on 4/10/18.
//  Copyright © 2018 Giorgio Ruscigno. All rights reserved.
//

import Pulley
import UIKit

//  MARK: Transition delegate
/// Manages the transition of the settings page on and off screen
extension PulleyViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func presentGlobalMediaList() {
        let primaryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaLibraryViewController")
        primaryViewController.modalPresentationStyle = .overFullScreen
        primaryViewController.transitioningDelegate = self
        DispatchQueue.main.async {
            self.present(primaryViewController, animated: true, completion: nil)
        }
    }
}
