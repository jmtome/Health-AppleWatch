//
//  WeightPickerDataSource.swift
//  Heart Rate Monitor WatchKit Extension
//
//  Created by Juan Manuel Tome on 13/07/2020.
//  Copyright © 2020 Watch Coder. All rights reserved.
//

import WatchKit

public class Weight {
    var tenWeight: Double {
        didSet {
            self.weight = stringWeight()
        }
    }
    var unitWeight: Double {
        didSet {
            self.weight = stringWeight()
        }
    }
    var commaWeight: Double {
        didSet {
            self.weight = stringWeight()
        }
    }
    
    var weight: String = ""
    
    init(tenWeight: Double, unitWeight: Double, commaWeight: Double) {
        self.tenWeight = tenWeight
        self.unitWeight = unitWeight
        self.commaWeight = commaWeight
        self.weight = stringWeight()
    }
    
    func stringWeight() -> String {
        
        return "\(self.tenWeight * 10 + self.unitWeight + self.commaWeight / 10)"
    }
}

public class WeightPickerDataSource {
    
    private weak var tenPicker: WKInterfacePicker?
    private weak var unitPicker: WKInterfacePicker?
    private weak var commaPicker: WKInterfacePicker?
    
    var weight: Weight?
    
    
    public var selectedWeightDidUpdate: ((String) -> Void)?
  
    public init(
        tenPicker: WKInterfacePicker,
        unitPicker: WKInterfacePicker,
        commaPicker: WKInterfacePicker
        ){
        self.tenPicker = tenPicker
        self.unitPicker = unitPicker
        self.commaPicker = commaPicker
        self.weight = Weight(tenWeight: 1, unitWeight: 1, commaWeight: 1)
        setup()
    }
    // MARK: Setup
    private lazy var numbersPickerOptions: [Int] = {
        return Array(0...9)
    }()

    private func setup() {
        tenPicker?.setItems(numbersPickerOptions.map { tenValue in
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(tenValue)"
            return pickerItem
        })
        
        unitPicker?.setItems(numbersPickerOptions.map { unitValue in
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(unitValue)"
            return pickerItem
        })
        
        commaPicker?.setItems(numbersPickerOptions.map({ commaValue in
            let pickerItem = WKPickerItem()
            pickerItem.title = "\(commaValue)"
            return pickerItem
            })
        )
    }

    public func updateWeight(to weight: Weight) {
 
    }
    
    
    // MARK: User Interaction

    private var selectedTen: Int = 0
    private var selectedUnit: Int = 0
    private var selectedComma: Int = 0
    
    public func tenPickerUpdated(to index: Int) {
        selectedTen = numbersPickerOptions[index]
        
        self.weight?.tenWeight = Double(selectedTen)
        
        selectedWeightDidUpdate?(self.weight!.weight)
    }
    
    public func itemPickerUpdated(to index: Int) {
        selectedUnit = numbersPickerOptions[index]
        
        self.weight?.unitWeight = Double(selectedUnit)
        
        selectedWeightDidUpdate?(self.weight!.weight)
    }
    
    public func commaPickerUpdated(to index: Int) {
        
        selectedComma = numbersPickerOptions[index]
        
        self.weight?.commaWeight = Double(selectedComma)
        

        selectedWeightDidUpdate?(self.weight!.weight)
    }
    

    
}

