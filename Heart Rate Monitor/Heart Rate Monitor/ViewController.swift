//
//  ViewController.swift
//  Heart Rate Monitor
//
//  Created by Justin Trautman on 8/5/19.
//  Copyright © 2019 Watch Coder. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController {

    var session: WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(heartRate)
        heartRate.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heartRate.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        configureWatchKitSession()
    }

    private func configureWatchKitSession() {
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }

    let heartRate: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Heart rate is :"
        return label
    }()
}

extension ViewController: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message: \(message)")
        DispatchQueue.main.async {
            print(message["watch"]!)
            if let value = message["watch"] {
                print(value)
                self.heartRate.text = "\(value)"
            }
        }
    }
    
    
}
