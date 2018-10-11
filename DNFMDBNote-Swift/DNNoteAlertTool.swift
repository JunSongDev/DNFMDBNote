//
//  DNNoteAlertTool.swift
//  DNFMDBNote-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit

class DNNoteAlertTool: NSObject {
    
    static let alertTool = DNNoteAlertTool()
    

    public func alertForMessage(_ message: String, _ superClass: UIViewController, _ completeHandler: @escaping (() -> Void), cancleHandler: @escaping (() -> Void)) -> Void {
        
        let alertContol = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        alertContol.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (
            cancleAction) in
            cancleHandler()
        }))
        
        alertContol.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (sureAction) in
            completeHandler()
        }))
        // 回归主线程 present 提示框
        DispatchQueue.main.async {
            superClass.present(alertContol, animated: true, completion: nil)
        }
    }
}
