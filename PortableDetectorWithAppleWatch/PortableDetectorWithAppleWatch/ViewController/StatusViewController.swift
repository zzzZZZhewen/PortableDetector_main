//
//  StatusViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit
import AVFoundation

class StatusViewController: UIViewController {
    
    @IBOutlet weak var balanceAIcon: UIImageView!
    @IBOutlet weak var balanceBIcon: UIImageView!
    @IBOutlet weak var instrumentIcon: UIImageView!
    @IBOutlet weak var automobileIcon: UIImageView!
    
    @IBOutlet weak var cameraPreview: UIView!

    
    @IBOutlet weak var labelCarStatusValue: UILabel!
    @IBOutlet weak var labelCarStatusTitle: UILabel!
    @IBOutlet weak var labelInstrumentStatusValue: UILabel!
    @IBOutlet weak var labelInstrumentStatusTitle: UILabel!
    
    @IBOutlet weak var labelSignalB: UILabel!
    @IBOutlet weak var labelBatteryB: UILabel!
    @IBOutlet weak var labelSignalA: UILabel!
    @IBOutlet weak var labelBatteryA: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDetect: UIButton!
    
    @IBOutlet weak var labelDetect: UILabel!
    @IBOutlet weak var labelSave: UILabel!
    @IBOutlet weak var labelPrint: UILabel!
    @IBOutlet weak var labelStop: UILabel!
    @IBOutlet weak var labelCancel: UILabel!

    @IBOutlet weak var switchOverWeight: UISwitch!
    @IBOutlet weak var axleTypePicker: UIPickerView!
    
    @IBOutlet weak var imageViewSmallPlate: UIImageView!
    // detect table
    @IBOutlet weak var detectRecordTableView: UITableView!
    
    @IBOutlet var smallPlateTableViewCell: UITableViewCell!
    @IBOutlet var axleTypePickerTableViewCell: UITableViewCell!
    @IBOutlet var isOverweightTableViewCell: UITableViewCell!

    var smallPlateTableViewCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var plateTableViewCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
    var axleTableViewCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
    var axleTypePickerTableViewCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
    var weightTableViewCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
    var isOverweightTableViewCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
    var overweightTableViewCellIndexPath = NSIndexPath(forRow: 5, inSection: 0)
    var speedTableViewCellIndexPath = NSIndexPath(forRow: 6, inSection: 0)
    
    var isAxleTypePickerTableViewCellVisible = false
    
    var axleTypes = truck_types.truckTypes
    var axleTypesRow = 0
    
    var deviceDataModel:DeviceStatusDataModel!
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    //当前检测状态
    var currentDetectStatus = btnStatusList.Default {
        didSet {
            setAllBtnStatus(currentDetectStatus.btnStatus)
        }
    }
    
    
    // MARK: - life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setIcons()
        setAllBtnStatus(currentDetectStatus.btnStatus)
        deviceDataModel = DeviceStatusDataModel(delegate: self)
        deviceDataModel.startSocket()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewLayer = cameraPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            if let orientation = AVCaptureVideoOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue) {
                previewLayer.connection?.videoOrientation = orientation
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.detectRecordTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// MARK: - navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDetail" {
            if let controller = segue.destinationViewController as? SingleDetailViewController, cell = sender as? SingleRecordDetailTableViewCell {
                controller.detailStyle = .TextFiledOnly
                controller.detailName = cell.nameLabel.text
                controller.detailValue = cell.valueLabel.text
                //controller.detectedRecord = self.detectedRecord
            }
        }
        if segue.identifier == "showImage" {
            if let controller = segue.destinationViewController as? SingleDetailViewController {
                controller.detailName = "检测图片"
                controller.detailStyle = DetailStyle.FullScaleImageOnly
                //controller.detectedRecord = self.detectedRecord
            }
        }
    }
    
    
    // MARK: - event
    
    
    @IBAction func btnCancelTouchUpInside(sender: UIButton) {
        print("取消操作")
        deviceDataModel.cancelDetect()
    }
    
    @IBAction func btnStopTouchUpInside(sender: UIButton) {
        deviceDataModel.stopDetect()
    }
    
    @IBAction func btnDetectTouchUpInside(sender: UIButton) {
        deviceDataModel.startDetect()
    }
    
    @IBAction func btnSaveTouchUpInside(sender: UIButton) {
        deviceDataModel.saveRecord()
    }
    
    @IBAction func btnPrintTouchUpInside(sender: UIButton) {
        //  deviceDataModel.Print()
    }
    
    
    @IBAction func switchOverweightValueChanged(sender: UISwitch) {
        print("changed")
    }
    
    // MARK: - private
    
    func setIcons() {
        self.balanceAIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.balanceBIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.instrumentIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
        self.automobileIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
    }
    
    //更新设备状态
    func loadDeviceStatus(deviceStatusDatatModel:DeviceStatusDataModel){
        dispatch_sync(dispatch_get_main_queue(), {
            self.currentDetectStatus = deviceStatusDatatModel.detectStatus
            
            self.labelCarStatusValue.text = deviceStatusDatatModel.labelCarStatusValue
            self.labelCarStatusTitle.text = deviceStatusDatatModel.labelCarStatusTitle
            self.labelInstrumentStatusValue.text = deviceStatusDatatModel.labelInstrumentStatusValue
            self.labelInstrumentStatusTitle.text = deviceStatusDatatModel.labelInstrumentStatusTitle
            
            self.labelSignalB.text = deviceStatusDatatModel.labelSignalB
            self.labelBatteryB.text = deviceStatusDatatModel.labelBatteryB
            self.labelSignalA.text = deviceStatusDatatModel.labelSignalA
        })
    }
    
    //更新检测记录情况
    func loadDetectRecord(deviceStatusDatatModel:DeviceStatusDataModel){
        dispatch_sync(dispatch_get_main_queue(), {
            self.detectRecordTableView.reloadData()
        })
    }
    
    func setButtonStatus(button:UIButton, buttonLabel:UILabel, status:[AnyObject]){
        if let enabled = status[0] as? Bool {
            button.enabled = enabled
            buttonLabel.text = status[1] as? String
            if enabled {
                button.tintColor = buttonLabel.tintColor
                buttonLabel.textColor = buttonLabel.tintColor
            } else {
                button.tintColor = UIColor(white: 0, alpha: 0.5)
                buttonLabel.textColor = UIColor(white: 0, alpha: 0.5)
            }
        }
    }
    
    func setAllBtnStatus(btnStatusList:[[AnyObject]]){
        setButtonStatus(btnDetect, buttonLabel:labelDetect, status: btnStatusList[0])
        setButtonStatus(btnStop, buttonLabel: labelStop, status: btnStatusList[1])
        setButtonStatus(btnCancel, buttonLabel: labelCancel, status: btnStatusList[2])
        setButtonStatus(btnSave, buttonLabel: labelSave, status: btnStatusList[3])
        setButtonStatus(btnPrint, buttonLabel: labelPrint, status: btnStatusList[4])
    }
    
    func showAxleTypePicker() {
        isAxleTypePickerTableViewCellVisible = true
        
        smallPlateTableViewCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        plateTableViewCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        axleTableViewCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
        axleTypePickerTableViewCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
        weightTableViewCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
        isOverweightTableViewCellIndexPath = NSIndexPath(forRow: 5, inSection: 0)
        overweightTableViewCellIndexPath = NSIndexPath(forRow: 6, inSection: 0)
        speedTableViewCellIndexPath = NSIndexPath(forRow: 7, inSection: 0)
        
        
        axleTypePicker.selectRow(axleTypesRow, inComponent: 0, animated: false)
        
        detectRecordTableView.beginUpdates()
        detectRecordTableView.insertRowsAtIndexPaths([axleTypePickerTableViewCellIndexPath], withRowAnimation: .Fade)
        detectRecordTableView.reloadRowsAtIndexPaths([axleTableViewCellIndexPath], withRowAnimation: .None)
        detectRecordTableView.endUpdates()
        
        detectRecordTableView.scrollToRowAtIndexPath(axleTypePickerTableViewCellIndexPath, atScrollPosition: .Middle, animated: true)
    }
    
    func hideAxleTypePicker() {
        if isAxleTypePickerTableViewCellVisible {
            isAxleTypePickerTableViewCellVisible = false
            
            smallPlateTableViewCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            plateTableViewCellIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            axleTableViewCellIndexPath = NSIndexPath(forRow: 2, inSection: 0)
            axleTypePickerTableViewCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            weightTableViewCellIndexPath = NSIndexPath(forRow: 3, inSection: 0)
            isOverweightTableViewCellIndexPath = NSIndexPath(forRow: 4, inSection: 0)
            overweightTableViewCellIndexPath = NSIndexPath(forRow: 5, inSection: 0)
            speedTableViewCellIndexPath = NSIndexPath(forRow: 6, inSection: 0)
            
            detectRecordTableView.beginUpdates()
            detectRecordTableView.reloadRowsAtIndexPaths([axleTableViewCellIndexPath], withRowAnimation: .None)
            detectRecordTableView.deleteRowsAtIndexPaths([axleTypePickerTableViewCellIndexPath], withRowAnimation: .Fade)
            detectRecordTableView.endUpdates()
        }
    }
}

extension StatusViewController: DeviceStatusDelegate {
    func statusDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel){
        loadDeviceStatus(dataModel)//加载下层计算后的数据模型显示界面
    }
    
    func detectDataModel(didGetStautsWithDataModel dataModel: DeviceStatusDataModel){
        loadDetectRecord(dataModel)//加载下层计算后的数据模型显示界面
    }
    func cameraControllerDidInitiated(cameraController: CameraController) {
        if let previewLayer = cameraController.videoPreviewLayer {
            previewLayer.frame = cameraPreview.bounds
            if let orientation = AVCaptureVideoOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue) {
                previewLayer.connection?.videoOrientation = orientation
            }
            self.cameraPreviewLayer = previewLayer
            self.cameraPreview.layer.addSublayer(previewLayer)
        }
    }
}

extension StatusViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAxleTypePickerTableViewCellVisible {
            return 8
        } else {
            return 7
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == smallPlateTableViewCellIndexPath.row {
            return 60.0
        }
        if isAxleTypePickerTableViewCellVisible && indexPath.row == axleTypePickerTableViewCellIndexPath.row {
            return 80.0
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let id = "SingleRecordDetailTableViewCellID"
        if indexPath.row == smallPlateTableViewCellIndexPath.row {
            ///
            return smallPlateTableViewCell
        }
        if indexPath.row == plateTableViewCellIndexPath.row {
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
                cell.nameLabel.text = "车牌号码"
                cell.valueLabel.text = ""
                return cell
            }
        }
        if indexPath.row == axleTableViewCellIndexPath.row {
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
                cell.nameLabel.text = "车辆轴型"
                cell.valueLabel.text = axleTypes[axleTypesRow].rawValue
                if isAxleTypePickerTableViewCellVisible {
                    cell.valueLabel.textColor = cell.valueLabel.tintColor
                } else {
                    cell.valueLabel.textColor = UIColor(white: 0, alpha: 0.5)
                }
                return cell
            }
        }
        if isAxleTypePickerTableViewCellVisible && indexPath.row == axleTypePickerTableViewCellIndexPath.row {
            return axleTypePickerTableViewCell
        }
        if indexPath.row == weightTableViewCellIndexPath.row {
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
                cell.nameLabel.text = "车辆重量"
                cell.valueLabel.text = ""
                return cell
            }
        }
        if indexPath.row == isOverweightTableViewCellIndexPath.row {
            return isOverweightTableViewCell
        }
        if indexPath.row == overweightTableViewCellIndexPath.row {
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
                cell.nameLabel.text = "超载重量"
                cell.valueLabel.text = ""
                return cell
            }
        }
        if indexPath.row == speedTableViewCellIndexPath.row {
            if let cell = tableView.dequeueReusableCellWithIdentifier(id) as? SingleRecordDetailTableViewCell {
                cell.nameLabel.text = "通过速度"
                cell.valueLabel.text = ""
                return cell
            }
        }
        return UITableViewCell(style: .Default, reuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        if indexPath.row == isOverweightTableViewCellIndexPath.row {
            switchOverWeight.setOn(!switchOverWeight.on, animated: true)
        }
        
        if indexPath.row == axleTableViewCellIndexPath.row {
            if !isAxleTypePickerTableViewCellVisible {
                showAxleTypePicker()
            } else {
                hideAxleTypePicker()
            }
            return nil
        }

        if indexPath.row == isOverweightTableViewCellIndexPath.row {
            return nil
        }

        hideAxleTypePicker()
        return indexPath
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//         tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
//    }

}

extension StatusViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return axleTypes.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var mastring = NSMutableAttributedString(string: axleTypes[row].rawValue)
        //mastring.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(11.0), range: NSRange(location: 0, length: mastring.length))
        return axleTypes[row].rawValue
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        axleTypesRow = row
        detectRecordTableView.reloadRowsAtIndexPaths([axleTableViewCellIndexPath], withRowAnimation: .None)
    }
}