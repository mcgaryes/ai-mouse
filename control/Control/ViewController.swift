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

class ViewController: UIViewController, BLEDelegate, ControlsViewControlerDelegate
{
    
    // MARK: Internal Properties
    
    //@IBOutlet var joystickView: SKView!
    @IBOutlet var dataLabel: UILabel!

    // MARK: Internal Methods
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad()
    {
        ble = BLE()
        ble.delegate = self
    }
    
    override func viewDidLayoutSubviews()
    {
//        let size = CGSize(width: view.frame.size.width, height: view.frame.size.height)
//        let joystickScene = JoystickScene(size: size)
//        
//        joystickScene.scaleMode = .resizeFill
//        joystickScene.joystickDelegate = self
//        joystickView.presentScene(joystickScene)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedControls" {
            (segue.destination as? ControlsViewController)?.delegate = self
        }
    }
    
    // MARK: JoystickSceneDelegate Methods
    
    func controlsDidUpdateSpeeds(speeds: (left: Int, right: Int))
    {
        if self.speeds != speeds {
            self.speeds = speeds
            var speedsStr = "\(speeds.left),\(speeds.right)"
            while speedsStr.lengthOfBytes(using: .ascii) < 10 {
                speedsStr = speedsStr + "&"
            }
            blewrite(value: speedsStr)
        }
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
        ble.startScanning()
    }
    
    func bleDidReceiveData(data: NSData?)
    {
        //print(data);
    }
    
    // ============================================================
    // === Private API ============================================
    // ============================================================
    
    // MARK: Private Properties
    
    private var ble:BLE!
    private var speeds:(Int, Int) = (0,0)
    // MARK: Private Methods
    
    private func blewrite(value:String)
    {
        if let data = value.data(using: .utf8) {
            print(value)
            ble.write(data: NSData(data: data))
        }
    }
    
}

