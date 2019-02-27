//
//  UIActivityHUD.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol UIActivityHUD: class {
    func showHUD(status: String?) // Presents an activity view indicating an loading process
    func hideHUD()
}

// MARK :- GPMessageViewProtocol default implementation for UIViewController subclasses

extension GPUIActivityHUD where Self: UIViewController {
    
    func showHUD(status: String?=nil) {
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show(withStatus: status)
    }
    
    func hideHUD() {
        SVProgressHUD.dismiss()
    }
}
