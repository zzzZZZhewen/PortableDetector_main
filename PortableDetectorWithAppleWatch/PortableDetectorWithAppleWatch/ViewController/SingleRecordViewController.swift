//
//  SingleRecordViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/25.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class SingleRecordViewController: UIViewController {
    
    @IBOutlet weak var singleRecordTableView: UITableView!
    @IBOutlet var smallPlateTableViewCell: UITableViewCell!
    
    
    @IBOutlet weak var smallPlateImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    /// datamodel
    var detectedRecord: DetectedRecord!
    var detector: Detector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateDetails()
    }
    
    /// MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDetail" {
            if let controller = segue.destinationViewController as? SingleDetailViewController, cell = sender as? SingleRecordDetailTableViewCell {
                controller.detailStyle = .TextFiledOnly
                controller.detailName = cell.nameLabel.text
                controller.detailValue = cell.valueLabel.text
                controller.detectedRecord = self.detectedRecord
            }
        }
        if segue.identifier == "showImage" {
            if let controller = segue.destinationViewController as? SingleDetailViewController {
                controller.detailName = "检测图片"
                controller.detailStyle = DetailStyle.FullScaleImageOnly
                controller.detectedRecord = self.detectedRecord
            }
        }
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func updateDetails() {
        self.singleRecordTableView.reloadData()
    }

}

extension SingleRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60.0
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return smallPlateTableViewCell
        }
        let id = "SingleRecordDetailTableViewCellID"
        if let cell = singleRecordTableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
            switch indexPath.row {
            case 1:
                cell.nameLabel.text = "车牌号码"
                cell.valueLabel.text = detectedRecord.plate_number
                break
            case 2:
                cell.nameLabel.text = "检测时间"
                cell.valueLabel.text = detectedRecord.detect_time
                break
            case 3:
                cell.nameLabel.text = "车辆轴型"
                cell.valueLabel.text = detectedRecord.truck_type.rawValue
                break
            case 4:
                cell.nameLabel.text = "车辆重量"
                cell.valueLabel.text =  String(format: "%.1f", detectedRecord.weight)
                break
            case 5:
                cell.nameLabel.text = "超载重量"
                cell.valueLabel.text = String(format: "%.1f", detectedRecord.over_weight)
                break
            case 6:
                cell.nameLabel.text = "是否超载"
                cell.valueLabel.text = detectedRecord.over_weight > 0.0 ? "是" : "否"
                break
            case 7:
                cell.nameLabel.text = "通过速度"
                cell.valueLabel.text =  String(format: "%.1f km/h", detectedRecord.speed)
                break
            case 8:
                cell.nameLabel.text = "检测人员"
                cell.valueLabel.text = detector.detectorName
                break
            default:
                break
            }
            
            return cell
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row == 3 || indexPath.row == 2 || indexPath.row == 8 {
            return nil
        }
        
        return indexPath
    }
}

extension SingleRecordViewController: UIGestureRecognizerDelegate {
    
}
