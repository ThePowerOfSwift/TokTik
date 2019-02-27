//
//  UIMessages.swift
//  TokTik
//
//  Created by Daniel Bolivar Herrera on 26/02/2019.
//  Copyright © 2019 Daniel Bolivar Herrera. All rights reserved.
//

import UIKit
import SwiftMessages

protocol UIMessageProtocol {
    func showMessage(title: String, message: String, type: MessageType, position: MessagePosition) // Presents non UI Blocking message to the user
}

enum MessageType {
    case error
    case warning
    case success
}

enum MessagePosition {
    case top
    case center
    case bottom
}

// MARK :- GPMessageViewProtocol default implementation for UIViewController subclasses

extension UIMessageProtocol where Self: UIViewController {
    
    private func getMessagePosition(position: MessagePosition) -> SwiftMessages.PresentationStyle {
        
        if position == .center {
            return .center
        } else if position == .bottom {
            return .bottom
        } else {
            return .top
        }
    }
    
    private func getMessageTheme(type: MessageType) -> Theme {
        
        if type == .warning {
            return .warning
        } else if type == .error {
            return .error
        } else {
            return .success
        }
    }
    
    private func configure(messageView:MessageView, type:MessageType) {
        
        messageView.configureTheme(self.getMessageTheme(type: type))
        
        // This could also be further customized!
        switch (type) {
            
        case .warning:
            
            messageView.backgroundView.backgroundColor = UIColor(red: 0.8, green: 0.7294, blue: 0.5098, alpha: 1.0) /* #ccba82 */
        
        case .success:
            
            messageView.backgroundView.backgroundColor = UIColor(red: 0.5725, green: 0.749, blue: 0.4118, alpha: 1.0) /* #92bf69 */
            
        case .error:
            messageView.backgroundView.backgroundColor = UIColor(red: 0.8667, green: 0.3294, blue: 0.3294, alpha: 1.0) /* #dd5454 */
        }
        
    }
    
    func showMessage(title: String, message: String, type: MessageType, position: MessagePosition = .top) {
        
        let messageView = MessageView.viewFromNib(layout: .cardView)
        self.configure(messageView: messageView, type: type)
        messageView.configureDropShadow()
        messageView.configureContent(title: title, body: message)
        messageView.button?.isHidden = true
        
        messageView.layoutMarginAdditions = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = self.getMessagePosition(position: position)
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        SwiftMessages.show(config: config, view: messageView)
    }
}
