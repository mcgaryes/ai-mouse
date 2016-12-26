//
//  ViewController.swift
//  Control
//
//  Created by Eric McGary on 11/19/16.
//
//

import UIKit
import CoreBluetooth
import SpriteKit

class ViewController: UIViewController, BLEDelegate, JoystickSceneDelegate
{
    
    // MARK: Internal Properties
    
    @IBOutlet var joystickView: SKView!
    @IBOutlet var dataLabel: UILabel!

    // MARK: Internal Methods
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad()
    {
        //controlsContainer.alpha = 0.25
        //controlsContainer.isUserInteractionEnabled = false
        ble = BLE()
        ble.delegate = self
    }
    
    override func viewDidLayoutSubviews()
    {
        let size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        let joystickScene = JoystickScene(size: size)
        
        joystickScene.scaleMode = .resizeFill
        joystickScene.joystickDelegate = self
        joystickView.presentScene(joystickScene)
        
    }
    
    // MARK: JoystickSceneDelegate Methods
    
    func joystickScene(didUpdate data: (leftMotorSpeed: Double, rightMotorSpeed: Double))
    {
        
        // -253,-253&
        
        var dataStr = "\(Int(data.leftMotorSpeed)),\(Int(data.rightMotorSpeed))&"
        
        while dataStr.lengthOfBytes(using: .ascii) < 10 {
            dataStr += "&"
        }
        
        print(dataStr)
        
        guard let ap = ble.activePeripheral, ap.state == .connected else { return }
        blewrite(value: dataStr)
    }
    
    // MARK: BLEDelegate Methods
    
    func bleDidUpdate(state: CBManagerState)
    {
        
        switch state {
        
            case .poweredOn, .resetting:
                
                ble.startScanning()
                NotificationCenter.default.post(Notifications.bluetoothWillConnect)
            
            case .poweredOff, .unsupported, .unauthorized, .unknown:
                
                NotificationCenter.default.post(Notifications.bluetoothDidFail)
    
        }
    }
    
    func bleDidConnect(peripheral: CBPeripheral)
    {
        NotificationCenter.default.post(Notifications.bluetoothDidConnect)
        ble.centralManager.stopScan()
    }
    
    func bleDidDisconenct(peripheral:CBPeripheral, error:Error?)
    {
        NotificationCenter.default.post(Notifications.bluetoothDidDisconnect)
        if error != nil {
            print(error)
        }
        ble.startScanning()
    }
    
    func bleDidReceiveData(data: NSData?)
    {
        print("bleDidReceiveData")
    }
    
    // ============================================================
    // === Private API ============================================
    // ============================================================
    
    // MARK: Private Properties
    
    private var ble:BLE!
    
    // MARK: Private Methods
    
    private func blewrite(value:String)
    {
        if let data = value.data(using: .utf8) {
            ble.write(data: NSData(data: data))
        }
    }
    
}

