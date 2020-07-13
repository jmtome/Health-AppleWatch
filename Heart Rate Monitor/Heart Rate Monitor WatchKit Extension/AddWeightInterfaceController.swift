//
//  AddWeightInterfaceController.swift
//  Heart Rate Monitor
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit
import WatchConnectivity

class AddWeightInterfaceController: WKInterfaceController {
    
    var weightPickerDataSource: WeightPickerDataSource!

    var healthStore: HKHealthStore?
    var weight: Double = 80.0
    var weightUnit = HKUnit(from: .kilogram)
    let session = WCSession.default
    
    
    @IBOutlet var tenWeight: WKInterfacePicker!
    @IBOutlet var unitWeight: WKInterfacePicker!
    @IBOutlet var commaWeight: WKInterfacePicker!
    @IBOutlet var weightLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        weightPickerDataSource = WeightPickerDataSource(
            tenPicker: tenWeight,
            unitPicker: unitWeight,
            commaPicker: commaWeight)
        weightPickerDataSource.selectedWeightDidUpdate = { [weak self] selectedWeight in
            self?.weightLabel.setText(selectedWeight)
            self?.weight = (selectedWeight as NSString).doubleValue
        }
        
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
    
//    override func awake(withContext context: Any?) {
//        timePickerDataSource = TimePickerDataSource(
//            hoursPicker: hourTimePicker,
//            minutesPicker: minuteTimePicker,
//            amPmPicker: amPmTimePicker,
//            interval: .fiveMinutes)
//
//        timePickerDataSource.selectedTimeDidUpdate = { [weak self] selectedTime in
//            let timeFormatter = DateFormatter()
//            timeFormatter.timeStyle = .short
//            timeFormatter.dateStyle = .none
//
//            self?.selectedTimeLabel.setText(timeFormatter.string(from: selectedTime))
//        }
//
//        timePickerDataSource.updateDate(to: Date())
//    }
    
    
    @IBAction func tenPickerDidUpdate(_ index: Int) {
        print(index)
        weightPickerDataSource.tenPickerUpdated(to: index)
    }
    
    @IBAction func unitPickerDidUpdate(_ index: Int) {
        print(index)

        weightPickerDataSource.itemPickerUpdated(to: index)
    }
    
    @IBAction func commaPickerDidUpdate(_ index: Int) {
        weightPickerDataSource.commaPickerUpdated(to: index)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func sendWeightToiPhone() {
        print(self.weight)
        self.sendInfoToiPhone("\(weight)")
    }
    
    private func sendInfoToiPhone(_ weight: String) {
        let data: [String: Any] = ["weight": weight as Any]
        print(data)
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }

}
extension AddWeightInterfaceController: WCSessionDelegate {
func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
    }
}
