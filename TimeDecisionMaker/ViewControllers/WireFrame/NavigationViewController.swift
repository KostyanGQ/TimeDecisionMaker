//
//  NavigationViewController.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/24/19.
//

import UIKit

class NavigationVC: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenBounds = UIScreen.main.bounds
        let notificationViewFrame = CGRect(x: 0,
                                           y: screenBounds.height - self.notificationViewCurrentHeight,
                                           width: screenBounds.width,
                                           height: notificationViewMaxHeight)
        self.notificationView?.frame = notificationViewFrame
        
        let WUI_offset1 : CGFloat = 14
        let WUI_offset2 : CGFloat = 4
        let notificationLabelFrame = CGRect(x: WUI_offset1,
                                            y: WUI_offset2,
                                            width: notificationViewFrame.size.width - WUI_offset1 - WUI_offset1,
                                            height: notificationViewFrame.size.height - WUI_offset2 - WUI_offset2)
        self.notificationLabel?.frame = notificationLabelFrame
        
        if let notificationLabel = self.notificationLabel, self.notificationViewCurrentHeight > 0 {
            self.view.bringSubviewToFront(notificationLabel)
        }
    }
    
    // MARK: -
    // MARK: - Private
    
    private let notificationViewMaxHeight: CGFloat = 50
    private var notificationViewCurrentHeight: CGFloat = 0
    
    private var notificationViewTimeout:  Double = 0
    private let notificationViewDuration: Double = 5
    private var notificationViewTimer:    Timer?
    
    private weak var notificationView:  UIView?
    private weak var notificationLabel: UILabel?
    

    
}
