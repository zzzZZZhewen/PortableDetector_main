//
//  RecognizePlate.swift
//  RecognizePlate
//
//  Created by 梁栋 on 16/2/23.
//  Copyright © 2016年 梁栋. All rights reserved.
//

import Foundation
import UIKit

protocol RecognizePlateDelegate: class {
    func didFinishRecognizePlate(recognizeResult:IdentifyResult)
}

class RecognizePlate {
    weak var delegate:RecognizePlateDelegate?
    
    init(delegate:RecognizePlateDelegate) {
        self.delegate = delegate
    }
    func recognizePlate(fileName:String) {
        var recognizePlateResult:IdentifyResult = IdentifyResult()
        
        recognizePlateResult = CVWrapper.recognizePlate(fileName)
        
        self.delegate?.didFinishRecognizePlate(recognizePlateResult)
    }

}
