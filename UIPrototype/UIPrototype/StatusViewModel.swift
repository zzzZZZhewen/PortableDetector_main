//
//  StatusViewModel.swift
//  UIPrototype
//
//  Created by 缪哲文 on 16/2/23.
//  Copyright © 2016年 缪哲文. All rights reserved.
//

import UIKit


protocol StatusViewModelDelegate: class {
    //func statusViewModel(viewModel: StatusViewModel, didUpdateLastRecord: RecordDataModel)
    func statusViewModel(viewModel:StatusViewModel, didShootSucceededWithImage image: UIImage)
}

class StatusViewModel: NSObject {
    
    weak var delegate: StatusViewModelDelegate?
    var cameraController: CameraController!

    init(delegate:StatusViewModelDelegate){
        super.init()
        self.delegate = delegate
        //initCameraController()
    }
    
    // MARK: - services
    /// 测试使用
    func shoot() {
        self.cameraController.shoot()
    }
    
    
}

extension StatusViewModel: CameraControllerProtocol, CameraControllerDelegate {
    
    func initCameraController() {
        self.cameraController = CameraController(delegate: self)
    }
    
    func cameraController(cameraController: CameraController, didShootSucceededWithImageData imageData: NSData) {
        if let image = UIImage(data: imageData) {
            self.delegate?.statusViewModel(self, didShootSucceededWithImage: image)
        }
    }
}

