//
//  NotificationKeys.swift
//  Control
//
//  Created by Eric McGary on 11/23/16.
//
//

import Foundation

class Notifications
{
    static let bluetoothDidConnect = Notification(name: Notification.Name(rawValue: "BLUETOOTH_DID_CONNECT"))
    static let bluetoothWillConnect = Notification(name: Notification.Name(rawValue: "BLUETOOTH_WILL_CONNECT"))
    static let bluetoothDidDisconnect = Notification(name: Notification.Name(rawValue: "BLUETOOTH_DID_DISCONNECT"))
    static let bluetoothDidFail = Notification(name: Notification.Name(rawValue: "BLUETOOTH_DID_FAIL"))
}
