//
//  TableViewCell.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/25.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class SingleRecordDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
