//
//  SingleDetailViewController.swift
//  PortableDetectorWithAppleWatch
//
//  Created by 缪哲文 on 16/2/27.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

enum DetailStyle {
    case TextFiledOnly
    case SmallImageOnly
    case FullScaleImageOnly
    case PickerViewOnly
}


protocol SingleDetailViewControllerDelegate: class {
    //didSucceeded
}

class SingleDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var pickerTableCell: UITableViewCell!
    @IBOutlet var textTableViewCell: UITableViewCell!
    @IBOutlet var datePickerTableCell: UITableViewCell!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var customPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var detailNameLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var fullScaleImage: UIImageView!
    
    @IBOutlet weak var titleIcon: UIImageView!
    

    var tintColor :UIColor!
    
    var detailName: String? = "记录详情"
    var detailValue: String? = ""
    
    var detailStyle = DetailStyle.TextFiledOnly
    
    weak var delegate: SingleDetailViewController?
    
    var detectedRecord: DetectedRecord?
    var detector: Detector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tintColor = doneButton.tintColor
        //自定义返回使得右滑失效
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        updateDetail()
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if detailStyle == .TextFiledOnly {
            textField.becomeFirstResponder()
        }
    }
    
    
    @IBAction func textFiledEditingChanged(sender: UITextField) {
        if sender.text == detailValue {
            doneButton.tintColor = UIColor(white: 0, alpha: 0.5)
            doneButton.enabled = false
        } else {
            doneButton.tintColor = tintColor
            doneButton.enabled = true
        }
    }
    
    @IBAction func cancelButtonTouchUpInside(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func doneButtonTouchUpInside(sender: UIButton) {
        //开异步线程修改
        if detailStyle == .TextFiledOnly {
            if detailName == "车牌号码" {
                detectedRecord?.plate_number = textField.text == nil ? "" : textField.text!
            }
        }
        self.navigationController?.popViewControllerAnimated(true)
    }

    //private 
    
    /// used before view appear
    func updateDetail() {
        detailNameLabel.text = detailName
        
        switch detailStyle {
        case .TextFiledOnly:
            tableView.hidden = false
            doneButton.hidden = false
            doneButton.tintColor = UIColor(white: 0, alpha: 0.5)
        case .FullScaleImageOnly:
            fullScaleImage.hidden = false
            fullScaleImage.image = UIImage(named: "big_photo")
            break
        default:
            break
        }

    }
}

extension SingleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if detailStyle == .TextFiledOnly {
            return 1
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if detailStyle == .TextFiledOnly {
            textField.text = detailValue
            return textTableViewCell
        }
        
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}

extension SingleDetailViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {

        return true
    }
    
}

extension SingleDetailViewController: UIGestureRecognizerDelegate {
    
}
