//
//  PeerServiceManager.swift
//  twoBoxes
//
//  Created by Justin Chang on 3/28/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerServiceManager: NSObject {
    private let PeerServiceType = "space-shoot"
    var delegate:PeerServiceManagerDelegate?
    
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: PeerServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: PeerServiceType)
        
        super.init()
        
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func send(gameState:[CGFloat]) {
        NSLog("%@", "sendPoint: \(gameState) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                var blockString:String = ""
                for i in gameState {
                    blockString += ("\(String(describing:i)), ")
                }
                try self.session.send(blockString.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
}

extension PeerServiceManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}

extension PeerServiceManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
}

extension PeerServiceManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)
        let input = str?.components(separatedBy: ", ")
        print("(((\(String(describing: input)))))")
        let mode = CGFloat(Double((input?[0])!)!)
        switch(mode) {
        case 0.0:
            /*
             input[0]: data mode: 0 = move command
             input[1]: x coordinate
             input[2]: y coordinate
             input[3]: z rotation
             input[4]: shield status
            */
            self.delegate?.coordChanged(manager: self, coord: [CGFloat(Double(input![1])!), CGFloat(Double(input![2])!), CGFloat(Double(input![3])!), CGFloat(Double(input![4])!)])
        case 1.0:
            /*
            input[0]: data mode: 1 = attack command
            input[1]: x coordinate
            input[2]: y coordinate
            input[3]: z rotation
            input[4]: dx velocity
            input[5]: dy velocity
            */
            self.delegate?.enemyFired(manager: self, info: [CGFloat(Double(input![1])!), CGFloat(Double(input![2])!), CGFloat(Double(input![3])!), CGFloat(Double(input![4])!), CGFloat(Double(input![5])!)])
        case 2.0:
            self.delegate?.enemyDied(manager: self)
        default:
            break;
        }
    }
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer didChangeState: \(peerID)")
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
}
