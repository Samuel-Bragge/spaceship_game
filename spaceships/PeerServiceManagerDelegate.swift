//
//  PeerServiceManagerDelegate.swift
//  twoBoxes
//
//  Created by Justin Chang on 3/28/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import Foundation
import SpriteKit

protocol PeerServiceManagerDelegate: class {
    func connectedDevicesChanged(manager: PeerServiceManager, connectedDevices: [String])
    func coordChanged(manager: PeerServiceManager, coord: [CGFloat])
    func enemyFired(manager: PeerServiceManager, info: [CGFloat])
}
