//
//  RecordTableViewCell.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/25.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var plateLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let swipe = UISwipeGestureRecognizer(target: self, action: "swipeGestureRecognizer:")
//        print("hehe")
//        self.addGestureRecognizer(swipe)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func swipeGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
//        print("haha")
//        if let swipe = gestureRecognizer as? UISwipeGestureRecognizer {
//            if swipe.direction == .Right {
//                dateLabel.hidden = true
//            }
//            if swipe.direction == .Left {
//                dateLabel.hidden = false
//            }
//        }
//    }
    
    
}
