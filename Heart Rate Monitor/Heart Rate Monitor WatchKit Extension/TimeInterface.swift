//
//  TimeInterface.swift
//  Heart Rate Monitor
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//

import WatchKit
import Foundation

class TimeInterfaceController: WKInterfaceController {

    var timePickerDataSource: TimePickerDataSource!
    @IBOutlet weak var hourTimePicker: WKInterfacePicker!
    @IBOutlet weak var minuteTimePicker: WKInterfacePicker!
    @IBOutlet weak var amPmTimePicker: WKInterfacePicker!
    @IBOutlet weak var selectedTimeLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        timePickerDataSource = TimePickerDataSource(
            hoursPicker: hourTimePicker,
            minutesPicker: minuteTimePicker,
            amPmPicker: amPmTimePicker,
            interval: .fiveMinutes)
        
        timePickerDataSource.selectedTimeDidUpdate = { [weak self] selectedTime in
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeFormatter.dateStyle = .none
            
            self?.selectedTimeLabel.setText(timeFormatter.string(from: selectedTime))
        }
        
        timePickerDataSource.updateDate(to: Date())
    }
    
    @IBAction func hourPickerDidUpdate(_ index: Int) {
        timePickerDataSource.hourPickerUpdated(to: index)
    }
    
    @IBAction func minutePickerDidUpdate(_ index: Int) {
        timePickerDataSource.minutePickerUpdated(to: index)
    }
    
    @IBAction func amPmPickerDidUpdate(_ index: Int) {
        timePickerDataSource.amPmPickerUpdated(to: index)
    }
    
}
