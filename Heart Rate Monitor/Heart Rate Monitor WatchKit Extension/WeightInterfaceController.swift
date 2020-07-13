//
//  WeightInterfaceController.swift
//  Heart Rate Monitor
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class WeightInterfaceController: WKInterfaceController {

    var healthStore: HKHealthStore?
    var weight: Double = 80.0
    var weightUnit = HKUnit(from: .kilogram)
    let session = WCSession.default

    @IBOutlet var weightLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session.delegate = self
        session.activate()
        
        let sampleType: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .bodyMass)!]
        healthStore = HKHealthStore()
        
        healthStore?.requestAuthorization(toShare: sampleType, read: sampleType, completion: { (success, error) in
            if success {
                self.fetchWeightData()
            }
        })
        
    }
    
    func fetchWeightData() {
        print("fetching weight data")
        
        
        let weightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                print("Weight => \(result.quantity)")
                self.weight = result.quantity.doubleValue(for: self.weightUnit)
                print("new weight is : \(self.weight)")
                self.weightLabel.setText("\(self.weight)")
            } else{
                print("OOPS didnt get height \nResults => \(results), error => \(error)")
            }
        }
        
        self.healthStore?.execute(query)

//        let quantityType: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .bodyMass)!]
//        let startDate = Date.init(timeIntervalSinceNow: -7*24*60*60)
//        let endDate = Date()
//        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
//        let sampleQuery = HKSampleQuery(sampleType: quantityType.first!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
//            DispatchQueue.main.async {
//
//                guard let samples = samples as? [HKQuantitySample] else { return }
//                self.process(samples, type: .bodyMass)
//            }
//        }
    }
    
    func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
        for sample in samples {
            print(sample)
            print("-\n")
        }
    }
//    func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
//        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
//        let updateHandler: (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = { query, samples, deletedObjects, queryAnchor, error in
//
//            guard let samples = samples as? [HKQuantitySample] else { return }
//            self.process(samples, type: quantityTypeIdentifier)
//        }
//
//        let query = HKAnchoredObjectQuery(type: HKObjectType.quantityType(forIdentifier: .heartRate)!, predicate: devicePredicate, anchor: nil, limit: HKObjectQueryNoLimit, resultsHandler: updateHandler)
//        query.updateHandler = updateHandler
//        healthStore?.execute(query)
//    }
//
//    private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
//        for sample in samples {
//            if type == .heartRate {
//                lastHeartRate = sample.quantity.doubleValue(for: beatCountPerMinute)
//                print("❤ Last Heart rate was: \(lastHeartRate)")
//            }
//            updateHeartRateLabel()
//            updateHeartRateSpeedLabel()
//
//        }
//    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    @IBAction func sendWeightToiPhone() {
        self.sendInfoToiPhone("\(weight)")
    }
    
    private func sendInfoToiPhone(_ weight: String) {
        let data: [String: Any] = ["weight": weight as Any]
        print(data)
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
extension WeightInterfaceController: WCSessionDelegate {
func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
    }
}
