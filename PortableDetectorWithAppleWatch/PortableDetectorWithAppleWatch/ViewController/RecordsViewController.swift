//  RecordsViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {

    /// tables
    @IBOutlet weak var searchPanelTableView: UITableView!
    @IBOutlet weak var recordsTableView: UITableView!
    
    
    /// static tablecells
    @IBOutlet var plateInputTableCell: UITableViewCell!
    @IBOutlet var conductorTableCell: UITableViewCell!
    @IBOutlet var conductorPickerTableCell: UITableViewCell!
    @IBOutlet var conductDateTableCell: UITableViewCell!
    @IBOutlet var datePickerTableCell: UITableViewCell!
    @IBOutlet var onlyOverRecordTableCell: UITableViewCell!
    
    
    /// static tablecells indexpath
    var plateInputTableCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var conductorTableCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    var conductorPickerTableCellIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var conductDateTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    var datePickerTableCellIndexPath = NSIndexPath(forRow: -1, inSection: 0)
    var onlyOverRecordTableCellIndexPath = NSIndexPath(forRow:3, inSection: 0)
    
    /// static tablecells visibility
    var conductorPickerTableCellVisible = false
    var datePickerTableCelVisible = false

    /// inputs
    @IBOutlet weak var plateTextField: UITextField!
    
    @IBOutlet weak var conductorLabel: UILabel!
    @IBOutlet weak var conductorPicker: UIPickerView!
    
    @IBOutlet weak var conductDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var onlyOverRecordSwitch: UISwitch!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    /// dataModel
    var conductDate = NSDate()
    var conductors = [Detector(id: 0, name: "全部"), Detector(id: 1, name: "缪哲文"), Detector(id: 2, name: "王柏元"), Detector(id: 3, name: "梁栋")]
    var conductorRow = 0
    
    var records = [DetectedRecord(id: 0, plate_number: "浙H12345", weight: 42.0, truck_type: truck_types.four.rawValue, axle_number: 4, speed: 12.0, detect_user: 1, plate_photo: "", truck_photo: "", location: "", site_latitude: "", latitude_dir: "", site_longitude: "", longtitude_dir: ""),
    DetectedRecord(id: 0, plate_number: "浙H12345", weight: 40.0, truck_type: truck_types.four.rawValue, axle_number: 4, speed: 12.0, detect_user: 2, plate_photo: "", truck_photo: "", location: "", site_latitude: "", latitude_dir: "", site_longitude: "", longtitude_dir: ""),
    DetectedRecord(id: 0, plate_number: "浙H12345", weight: 40.0, truck_type: truck_types.four.rawValue, axle_number: 4, speed: 12.0, detect_user: 3, plate_photo: "", truck_photo: "", location: "", site_latitude: "", latitude_dir: "", site_longitude: "", longtitude_dir: ""),
    DetectedRecord(id: 0, plate_number: "浙H12345", weight: 39.0, truck_type: truck_types.four.rawValue, axle_number: 4, speed: 12.0, detect_user: 2, plate_photo: "", truck_photo: "", location: "", site_latitude: "", latitude_dir: "", site_longitude: "", longtitude_dir: ""),
    DetectedRecord(id: 0, plate_number: "浙H12345", weight: 40.0, truck_type: truck_types.four.rawValue, axle_number: 4, speed: 12.0, detect_user: 1, plate_photo: "", truck_photo: "", location: "", site_latitude: "", latitude_dir: "", site_longitude: "", longtitude_dir: "")]

    /// life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setSearchPanel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    /// MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecord" {
            let controller = segue.destinationViewController as! SingleRecordViewController
            //controller.delegate = self
            
            if let indexPath = recordsTableView.indexPathForCell(sender as! UITableViewCell) {
                controller.detectedRecord = records[indexPath.row]
                var flag = false
                for detector in conductors {
                    if detector.detectorID == records[indexPath.row].detect_user {
                        controller.detector = detector
                        flag = true
                    }
                }
                if !flag {
                    controller.detector = Detector(id: 0, name: "未知")
                }
            }
        }
    }

    @IBAction func currentDetectButtonTappedInside(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// MARK: - searchPanel Event
    
    @IBAction func dateValueChanged(sender: UIDatePicker) {
        conductDate = datePicker.date
        updateConductDateLabel()
    }
    
    
    /// MARK: - private
    
    func setSearchPanel() {
        plateTextField.delegate = self
        
        datePicker.maximumDate = NSDate()
        
        updateConductDateLabel()
        updateConductorName()
    }
    
    func updateConductDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        conductDateLabel.text = formatter.stringFromDate(conductDate)
    }
    
    func updateConductorName() {
        conductorLabel.text = conductors[conductorRow].detectorName
    }
    
    
    func showDatePicker() {
        hideConductorPicker()
        datePickerTableCelVisible = true
        
        conductDateTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        datePickerTableCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
        onlyOverRecordTableCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        
        conductDateLabel.textColor = conductDateLabel.tintColor
        
        datePicker.setDate(conductDate, animated: false)
        
        searchPanelTableView.beginUpdates()
        searchPanelTableView.insertRowsAtIndexPaths([datePickerTableCellIndexPath], withRowAnimation: .Fade)
        searchPanelTableView.reloadRowsAtIndexPaths([conductDateTableCellIndexPath], withRowAnimation: .None)
        searchPanelTableView.endUpdates()
        
        searchPanelTableView.scrollToRowAtIndexPath(conductDateTableCellIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    func showConductorPicker() {
        hideDatePicker()
        conductorPickerTableCellVisible = true
        
        conductorTableCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        conductorPickerTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        conductDateTableCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
        onlyOverRecordTableCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        
        conductorLabel.textColor = conductorLabel.tintColor
        
        conductorPicker.selectRow(conductorRow, inComponent: 0, animated: false)
        
        searchPanelTableView.beginUpdates()
        searchPanelTableView.insertRowsAtIndexPaths([conductorPickerTableCellIndexPath], withRowAnimation: .Fade)
        searchPanelTableView.reloadRowsAtIndexPaths([conductorTableCellIndexPath], withRowAnimation: .None)
        searchPanelTableView.endUpdates()
        
        searchPanelTableView.scrollToRowAtIndexPath(conductorTableCellIndexPath, atScrollPosition: .Top, animated: true)
    }
    
    func hideDatePicker() {
        if datePickerTableCelVisible {
            datePickerTableCelVisible = false
            
            conductDateTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            datePickerTableCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            onlyOverRecordTableCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            
            conductDateLabel.textColor = UIColor(white: 0, alpha: 0.5)
            
            searchPanelTableView.beginUpdates()
            searchPanelTableView.reloadRowsAtIndexPaths([conductDateTableCellIndexPath], withRowAnimation: .None)
            searchPanelTableView.deleteRowsAtIndexPaths([datePickerTableCellIndexPath], withRowAnimation: .Fade)
            searchPanelTableView.endUpdates()
        }
    }
    
    func hideConductorPicker() {
        if conductorPickerTableCellVisible {
            conductorPickerTableCellVisible = false
            
            conductorTableCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            conductorPickerTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            conductDateTableCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            onlyOverRecordTableCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            
            conductorLabel.textColor = UIColor(white: 0, alpha: 0.5)
            
            searchPanelTableView.beginUpdates()
            searchPanelTableView.deleteRowsAtIndexPaths([conductorPickerTableCellIndexPath], withRowAnimation: .Fade)
            searchPanelTableView.reloadRowsAtIndexPaths([conductorTableCellIndexPath], withRowAnimation: .None)
            searchPanelTableView.endUpdates()
        }
    }

}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == searchPanelTableView {
            return 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchPanelTableView {
            var number = 4
            if conductorPickerTableCellVisible {
                number++
            }
            if datePickerTableCelVisible {
                number++
            }
            return number
        } else {
            return records.count
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == searchPanelTableView {
            if datePickerTableCelVisible && indexPath.row == datePickerTableCellIndexPath.row {
                return 100.0
            }
            if conductorPickerTableCellVisible && indexPath.row == conductorPickerTableCellIndexPath.row {
                return 100.0
            }
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == searchPanelTableView {
            if indexPath.row == plateInputTableCellIndexPath.row {
                return plateInputTableCell
            }
            if indexPath.row == conductorTableCellIndexPath.row {
                return conductorTableCell
            }
            if indexPath.row == conductDateTableCellIndexPath.row {
                return conductDateTableCell
            }
            if indexPath.row == onlyOverRecordTableCellIndexPath.row {
                return onlyOverRecordTableCell
            }
            if datePickerTableCelVisible && indexPath.row == datePickerTableCellIndexPath.row {
                return datePickerTableCell
            }
            if conductorPickerTableCellVisible && indexPath.row == conductorPickerTableCellIndexPath.row {
                return conductorPickerTableCell
            }
        } else {
            let id = "RecordTableViewCellID"
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? RecordsTableViewCell {
                let record = records[indexPath.row]
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .NoStyle
                cell.dateLabel.text = formatter.stringFromDate(record.detect_time_date)
                cell.plateLabel.text = record.plate_number
                cell.weightLabel.text = String(format: "%0.1f/%0.1f", record.weight, record.over_weight)
                return cell
            }
        }
        
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        plateTextField.resignFirstResponder()
        if tableView == searchPanelTableView {
            if indexPath.row == onlyOverRecordTableCellIndexPath.row {
                onlyOverRecordSwitch.setOn(!onlyOverRecordSwitch.on, animated: true)
            }
            if indexPath.row == plateInputTableCellIndexPath.row {
                plateTextField.becomeFirstResponder()
            }
            if indexPath.row == conductDateTableCellIndexPath.row || indexPath.row == conductorTableCellIndexPath.row {
                return indexPath
            }
            hideConductorPicker()
            hideDatePicker()
        } else {
            hideConductorPicker()
            hideDatePicker()
            return indexPath
        }
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == searchPanelTableView {
            if indexPath.row == conductDateTableCellIndexPath.row {
                if !datePickerTableCelVisible {
                    showDatePicker()
                } else {
                    hideDatePicker()
                }
            } else if indexPath.row == conductorTableCellIndexPath.row {
                if !conductorPickerTableCellVisible {
                    showConductorPicker()
                } else {
                    hideConductorPicker()
                }
            }
        } else {
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}

extension RecordsViewController: UITextFieldDelegate {
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let oldText: NSString = textField.text!
//        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
//        return true
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
        hideConductorPicker()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {

        return true
    }
}

extension RecordsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return conductors.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return conductors[row].detectorName
        }
        return nil
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        conductorRow = row
        updateConductorName()
    }
}


