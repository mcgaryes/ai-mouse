//
//  StatusViewController.swift
//  Control
//
//  Created by Eric McGary on 11/23/16.
//
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet var statusIndicator: UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatusViewController.handleNotification), name: Notifications.bluetoothDidConnect.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatusViewController.handleNotification), name: Notifications.bluetoothDidFail.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatusViewController.handleNotification), name: Notifications.bluetoothWillConnect.name, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StatusViewController.handleNotification), name: Notifications.bluetoothDidDisconnect.name, object: nil)
    }
    
    func handleNotification(n:Notification)
    {
        
        if n == Notifications.bluetoothDidDisconnect {
            
            statusIndicator.backgroundColor = .red
            
        } else if n == Notifications.bluetoothDidConnect {
            
            statusIndicator.backgroundColor = .green
            
        } else if n == Notifications.bluetoothWillConnect {
            
            statusIndicator.backgroundColor = .yellow
            
        } else if n == Notifications.bluetoothDidFail {
            
            statusIndicator.backgroundColor = .red
            
        }
        
    }
    
}
