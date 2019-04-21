//
//  ViewController.swift
//  trak
//
//  Created by Crowther, Arnaud on 4/8/19.
//  Copyright © 2019 Crowther, Arnaud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  
  // Attach UI listeners
  @IBAction func offsetInputChange(_ sender: UITextField) { calculate(); storeData() }
  @IBAction func startInputChange(_ sender: UITextField) { calculate(); storeData() }
  @IBAction func milesInputChange(_ sender: UITextField) { calculate(); storeData() }

  // Attach UI controls
  @IBOutlet var offsetTF: UITextField!
  @IBOutlet var datePickerTF: UITextField!
  @IBOutlet var milePickerTF: UITextField!
  @IBOutlet var allowedMilesLB: UILabel!
  @IBOutlet var totalTimeLB: UILabel!
  
  let datePicker = UIDatePicker()
  let milePicker = UIPickerView()
  
  var selectedMiles: String!
  let mileTypes = ["10,000", "12,000", "15,000"]
  
  
  
  // Create the date picker and attach the toolbar with 'done' action
  func createDatePicker() {
    datePicker.datePickerMode = .date
    datePickerTF.inputView = datePicker
    // Create toolbar
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeDatePicker))
    toolBar.setItems([doneButton], animated: true)
    datePickerTF.inputAccessoryView = toolBar
    // Set todays date
    datePicker.setDate(Date(), animated: false)
    datePickerTF.text = formatDate(Date())
    // Add listener for value change event
    datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
  }
  
  // Store date picker value on change
  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    datePickerTF.text = formatDate(sender.date)
    calculate()
  }
  
  // Close date picker and format the date for the date picker text field
  @objc func closeDatePicker() {
    datePickerTF.text = formatDate(datePicker.date)
    self.view.endEditing(true)
  }
  
  
  
  
  
  // Set up the miles picker with needed functions
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return mileTypes.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return mileTypes[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedMiles = mileTypes[row]
    milePickerTF.text = selectedMiles
    calculate()
  }
  
  // Create the mile picker and attach toolbar with 'done' action
  func createMilePicker() {
    milePicker.delegate = self
    milePickerTF.inputView = milePicker
    // Create toolbar
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeMilePicker))
    toolBar.setItems([doneButton], animated: true)
    milePickerTF.inputAccessoryView = toolBar
  }
  
  // Close the mile picker
  @objc func closeMilePicker() {
    self.view.endEditing(true)
  }
  
  
  
  
  
  // Create the offset input toolbar with 'done' action
  func createOffsetInputToolbar() {
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeOffsetInput))
    toolBar.setItems([doneButton], animated: true)
    offsetTF.inputAccessoryView = toolBar
  }
  
  // Close the offset input
  @objc func closeOffsetInput() {
    self.view.endEditing(true)
  }
  
  
  
  
  
  // Compute mileage statistics and update CTA label
  func calculate() {
    print("calc")
    let daysPassed = Calendar.current.dateComponents([.day], from: datePicker.date, to: Date()).day
    let miles = milePickerTF.text!.replacingOccurrences(of: ",", with: "")
    let allowedMiles = Double(daysPassed!) * (Double(miles)! / 365)
    var offset: Int! = 0
    if (Int(offsetTF.text!) != nil) {
      offset = Int(offsetTF.text!)
    }
    var result = Int(allowedMiles) + offset
    if (result < 0) {
      result = 0
    }
    // Display days passed and miles in labels
    let template = "%@ days"
    totalTimeLB.text = String(format: template, String(daysPassed!))
    allowedMilesLB.text = result.withCommas()
    // Pass values to be stored
    storeData()
  }
  
  // Store data to NS Defaults
  func storeData() {
    UserDefaults.standard.set(offsetTF.text, forKey: "offset")
    UserDefaults.standard.set(milePickerTF.text, forKey: "miles")
    UserDefaults.standard.set(datePickerTF.text, forKey: "start")
  }
  
  // Get data from NS Defaults
  func retreiveData() {
    // Offset
    let offset = UserDefaults.standard.string(forKey: "offset")
    offsetTF.text = offset
    // Start
    let start = UserDefaults.standard.string(forKey: "start")
    datePickerTF.text = start
    if (start != "" && start != nil) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat =  "MMM dd,yyyy"
      let date = dateFormatter.date(from: start!)
      datePicker.date = date!
    } else {
      datePicker.setDate(Date(), animated: false)
      datePickerTF.text = formatDate(Date())
    }
    // Miles
    var miles = UserDefaults.standard.string(forKey: "miles")
    if miles == nil {
      miles = "10,000"
    }
    var milePickerRow = 0;
    switch miles {
    case "12,000":
      milePickerRow = 1
    case "15,000":
      milePickerRow = 2
    default:
      milePickerRow = 0
    }
    pickerView(milePicker, didSelectRow: milePickerRow, inComponent: 0)
    milePicker.selectRow(milePickerRow, inComponent: 0, animated: true)
    milePickerTF.text = miles
  }
  
  // Return a formatted date, i.e. 'Apr 8, 2019'
  func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
  }
  
  // View did load init function
  override func viewDidLoad() {
    super.viewDidLoad()
    createDatePicker()
    createMilePicker()
    createOffsetInputToolbar()
    retreiveData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
}







extension Int {
  func withCommas() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value:self))!
  }
}
