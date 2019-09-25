//
//  RootWireFrame.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/24/19.
//

import UIKit


protocol IRootWireframe {
    
    func push(viewController: UIViewController)
    func present(viewController: UIViewController)
    func close(viewController: UIViewController)
    
    func openSettings()
    func closeSettings()
    

    
    func openMeet(meet: Meet)
    func closeMeet()
    
    func openMeetFile(meetFile : User)
    func closeMeetFile()
    
}


final class RootWireframe: NSObject, IRootWireframe {
   
    
    func openMeet(meet: Meet) {
        <#code#>
    }
    
    func closeMeet() {
        <#code#>
    }
    
    func openMeetFile(meetFile: User) {
        <#code#>
    }
    
    func closeMeetFile() {
        <#code#>
    }
    
    func openSettings() {
        <#code#>
    }
    
    func closeSettings() {
        <#code#>
    }

    
    
    static let sharedInstance = RootWireframe()
    
    
    func push(viewController: UIViewController) {
        self.rootNavigationController?.pushViewController(viewController,
                                                          animated: true)
    }
    
    func present(viewController: UIViewController) {
        self.rootNavigationController?.present(viewController,
                                               animated: true,
                                               completion: {
            
        })
    }
    
    func close(viewController: UIViewController) {
        let animated = true
        
        OperationQueue.main.addOperation {
            if viewController.navigationController != nil {
                viewController.navigationController?.popViewController(animated: animated)
            } else {
                viewController.dismiss(animated: animated, completion: {
                    
                })
            }
        }
    }

    
    private var rootNavigationController: NavigationVC?
    
    private var window: UIWindow? {
        didSet {
            let libraryVC = MeetViewController()
            self.rootNavigationController = NavigationVC(rootViewController: libraryVC)
            self.rootNavigationController?.setNavigationBarHidden(true, animated: false)
            
            self.window?.rootViewController = self.rootNavigationController
            self.window?.makeKeyAndVisible()
        }
    }

    
}
