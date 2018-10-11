//
//  DNEditorViewController.swift
//  DNFMDBNote-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit

class DNEditorViewController: UIViewController {

    var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.title = "Editor"
        self.setTextViewForSuper()
        self.setNavigationBarRightItem()
        // Do any additional setup after loading the view.
    }
    
    private func setTextViewForSuper() -> Void {
        
        self.textView = UITextView()
        self.textView?.font = UIFont.systemFont(ofSize: 16)
        
        self.view.addSubview(self.textView!)
        self.textView?.translatesAutoresizingMaskIntoConstraints = false
        self.textView?.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.textView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.textView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.textView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }

    private func setNavigationBarRightItem() {
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "insert"), style: .plain, target: self, action: #selector(rightItemTarget))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    // 获取当前的日期 年月日
    private func getCurrentDayDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    // 获取当前时间 时分秒
    private func getCurrentTimeDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    // 获取当前时间戳
    private func getCurrentTimeInterval() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        // 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = dateFormatter.string(from: Date())
        return dateString
    }
    @objc func rightItemTarget() {
        
        DNNoteAlertTool.alertTool.alertForMessage("是否存储", self, {
            
            let model = DNNoteModelSwift()
            model.content = self.textView?.text
            model.dayDate = self.getCurrentDayDate()
            model.timeDate = self.getCurrentTimeDate()
            model.timeline = self.getCurrentTimeInterval()
            
            DNDataManager.manager.insertData(model: model, successHandler: {
                
                self.navigationController?.popViewController(animated: true)
            })
            
        }) {
            print("cancle")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
