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
  @IBAction func offsetInputChange(_ sender: UITextField) { calculate() }
  @IBAction func startInputChange(_ sender: UITextField) { calculate() }
  @IBAction func milesInputChange(_ sender: UITextField) { calculate() }

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
    // Select first picker option
    pickerView(milePicker, didSelectRow: 0, inComponent: 0)
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
    let daysPassed = Calendar.current.dateComponents([.day], from: datePicker.date, to: Date()).day
    let template = "%@ days"
    totalTimeLB.text = String(format: template, String(daysPassed!))
    let miles = milePickerTF.text!.replacingOccurrences(of: ",", with: "")
    let allowedMiles = Double(daysPassed!) * (Double(miles)! / 365)
    var offset: Double! = 0
    if (Double(offsetTF.text!) != nil) {
      offset = Double(offsetTF.text!)
    }
    var result = allowedMiles + offset
    if (result < 0) {
      result = 0
    }
    allowedMilesLB.text = String(format: "%.0f", result)
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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.setNeedsStatusBarAppearanceUpdate()
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return .lightContent
  }
}
