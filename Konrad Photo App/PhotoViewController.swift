//
//  PhotoViewController.swift
//  Konrad Photo App
//
//  Created by Chris Wong on 2016-06-23.
//  Copyright © 2016 Chris Wong. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK: Properties
    @IBOutlet var photoSegmentedControl: UISegmentedControl!
    @IBOutlet var containerView: UIView!
    weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        
        self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("photoListID")
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        super.viewDidLoad()
        
    }

    // MARK: Actions
    @IBAction func photoSegmentedControlValueChanged(sender: AnyObject) {
        
        switch photoSegmentedControl.selectedSegmentIndex {
        case 0:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("photoListID")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController

        case 1:
            let newViewController = self.storyboard?.instantiateViewControllerWithIdentifier("mapID")
            newViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController!)
            self.currentViewController = newViewController

        default:
            break;
        }
    }
    
    // MARK: Helper functions
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        //subView.autoresizingMask
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|", options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    func cycleFromViewController(oldVC: UIViewController, toViewController newVC: UIViewController) {
        
        self.addChildViewController(newVC)
        self.addSubview(newVC.view, toView:self.containerView!)
        //view.addSubview(<#T##view: UIView##UIView#>)
        UIView.transitionWithView(containerView, duration: 1, options: .TransitionFlipFromLeft, animations: {}) { (Bool) -> Void in
            self.hideContainer(oldVC)
            newVC.didMoveToParentViewController(self)
        }
        
    }
    
    func hideContainer(currentViewController: UIViewController){
        currentViewController.willMoveToParentViewController(nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParentViewController()
    }
    
}
