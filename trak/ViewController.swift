//
//  ViewController.swift
//  trak
//
//  Created by Crowther, Arnaud on 4/8/19.
//  Copyright © 2019 Crowther, Arnaud. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  
  
  // Attach UI controls
  @IBOutlet var datePickerTF: UITextField!
  @IBOutlet var milePickerTF: UITextField!
  
  let datePicker = UIDatePicker()
  let milePicker = UIPickerView()
  
  var selectedMiles: String?
  let mileTypes = ["10,000", "12,000", "15,000"]
  
  
  
  /// Build the date picker and attach the toolbar with 'done' action
  func createDatePicker() {
    datePicker.datePickerMode = .date
    datePickerTF.inputView = datePicker
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeDatePicker))
    toolBar.setItems([doneButton], animated: true)
    datePickerTF.inputAccessoryView = toolBar
  }
  /// Close date picker and format the date for the date picker text field
  @objc func closeDatePicker() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    datePickerTF.text = dateFormatter.string(from: datePicker.date)
    self.view.endEditing(true)
  }
  
  
  
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
  
  func createMilePicker() {
    milePicker.delegate = self
    milePickerTF.inputView = milePicker
    let toolBar = UIToolbar()
    toolBar.sizeToFit()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(closeMilePicker))
    toolBar.setItems([doneButton], animated: true)
    milePickerTF.inputAccessoryView = toolBar
  }
  
  @objc func closeMilePicker() {
    self.view.endEditing(true)
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createDatePicker()
    createMilePicker()
  }

}

