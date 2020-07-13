//
//  WeightInterfaceController.swift
//  Heart Rate Monitor
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//

import UIKit
import WatchKit
import HealthKit
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    // MARK: - Outlets
    @IBOutlet var heartScene: WKInterfaceSKScene!
    @IBOutlet var bpmLabel: WKInterfaceLabel!
    @IBOutlet var heartRateSpeedLabel: WKInterfaceLabel!
    
    // MARK: - Properties
    var healthStore: HKHealthStore?
    var lastHeartRate = 0.0
    var beatCountPerMinute = HKUnit(from: "count/min")
    let session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session.delegate = self
        session.activate()
        
        let sampleType: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .bodyMass)!]
        healthStore = HKHealthStore()
        
        healthStore?.requestAuthorization(toShare: sampleType, read: sampleType, completion: { (success, error) in
            if success {
                self.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
            }
        })
        // Configure interface objects here.
    }
    
    func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, samples, deletedObjects, queryAnchor, error in
            
            guard let samples = samples as? [HKQuantitySample] else { return }
            self.process(samples, type: quantityTypeIdentifier)
        }
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
        query.updateHandler = updateHandler
        healthStore?.execute(query)
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        for sample in samples {
            if type == .heartRate {
                lastHeartRate = sample.quantity.doubleValue(for: beatCountPerMinute)
                print("❤ Last Heart rate was: \(lastHeartRate)")
            }
            updateHeartRateLabel()
            updateHeartRateSpeedLabel()
            
        }
    }
    
    private func sendInfoToiPhone(_ heartRate: String) {
        let data: [String: Any] = ["watch": heartRate as Any]
        print(data)
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
    
    private func updateHeartRateLabel() {
        let heartRate = String(Int(lastHeartRate))
        bpmLabel.setText(heartRate)
        sendInfoToiPhone(heartRate)
    }
    
    private func updateHeartRateSpeedLabel() {
        switch lastHeartRate {
        case _ where lastHeartRate > 130:
            heartRateSpeedLabel.setText("High")
            heartRateSpeedLabel.setTextColor(.red)
        case _ where lastHeartRate > 100:
            heartRateSpeedLabel.setText("Moderate")
            heartRateSpeedLabel.setTextColor(.yellow)
        default:
            heartRateSpeedLabel.setText("Low")
            heartRateSpeedLabel.setTextColor(.blue)
        }
    }

}

extension InterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    
}
