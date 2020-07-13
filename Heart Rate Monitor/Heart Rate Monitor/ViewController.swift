//
//  WeightInterfaceController.swift
//  Heart Rate Monitor
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//


import UIKit
import WatchConnectivity
import HealthKit

class ViewController: UIViewController {

    var session: WCSession?
    var weightValue: Double? = 10.0
    var healthStore: HKHealthStore?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(heartRate)
        view.addSubview(weight)
        healthStore = HKHealthStore()
        heartRate.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heartRate.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        weight.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weight.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true 
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
    let weight: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .systemTeal
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weight rate is :"
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
            //print(message["watch"]!)
            if let value = message["watch"] {
                print(value)
                self.heartRate.text = "\(value)"
            }
            if let weightMSG = message["weight"] {
                print(weightMSG)
                self.weight.text = "\(weightMSG)"
                self.weightValue = (weightMSG as! NSString).doubleValue / 2
            }
            self.writeWeight()
        }
    }
    
    func writeWeight() {

        if let type = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit(from: .kilogram), doubleValue: weightValue!)
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            self.healthStore?.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(error)")
            })
        }
    }
    
    
}
