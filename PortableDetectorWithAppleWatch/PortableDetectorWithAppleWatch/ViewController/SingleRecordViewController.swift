//
//  SingleRecordViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/25.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class SingleRecordViewController: UIViewController {
    
    @IBOutlet weak var SingleRecordTableView: UITableView!
    @IBOutlet var smallPlateTableViewCell: UITableViewCell!
    
    
    @IBOutlet weak var smallPlateImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    /// datamodel
    var detectedRecord: DetectedRecord!
    var detector: Detector!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        updateDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func updateDetails() {
        
        // 更换两张图片
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
            return 80.0
        }
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return smallPlateTableViewCell
        }
        let id = "SingleRecordDetailTableViewCellID"
        if let cell = SingleRecordTableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
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
                cell.nameLabel.text = "车辆型号"
                cell.valueLabel.text = detectedRecord.truck_type
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
        return nil
    }
}
