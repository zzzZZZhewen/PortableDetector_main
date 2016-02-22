//
//  StatusViewController.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/21.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var balanceAIcon: UIImageView!
    @IBOutlet weak var balanceBIcon: UIImageView!
    @IBOutlet weak var instrumentIcon: UIImageView!
    @IBOutlet weak var automobileIcon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setIcons()
        
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
    
    
    // MARK: - private
    
    func setIcons() {
        self.balanceAIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.balanceBIcon.tintColor = UIColor(red: 236/255, green: 63/255, blue: 140/255, alpha: 1.0)
        self.instrumentIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
        self.automobileIcon.tintColor = UIColor(red: 57/255, green: 177/255, blue: 198/255, alpha: 1.0)
    }
}
