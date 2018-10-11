//
//  ViewController.swift
//  DNFMDBNote-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Note"
        
        self.setInsertNoteButton()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = UIColor(red: 245/255.0,
                                                 green: 245/255.0,
                                                 blue: 245/255.0,
                                                 alpha: 1.0)
        self.tableView .register(DNNoteCellSwift.self, forCellReuseIdentifier: "DNNoteCellSwift")
        //self.tableView.register(UINib.init(nibName: "DNNoteSwiftCell", bundle: nil), forCellReuseIdentifier: "DNNoteSwiftCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigateBar = UINavigationBar.appearance()
        var navigateAttribute = Dictionary<NSAttributedString.Key , Any>()
        navigateAttribute[NSAttributedString.Key.foregroundColor] = UIColor.white
        navigateAttribute[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 20)
        navigateBar.titleTextAttributes = navigateAttribute
        // 设置标题 按钮
        self.tableView.reloadData()
    }
    
    private func setInsertNoteButton() -> Void {
        
        let insertButton = UIButton()
        insertButton.setImage(UIImage(named: "insert"), for: .normal)
        insertButton.backgroundColor = .cyan
        insertButton.layer.cornerRadius = SCREEN_W*0.08
        insertButton.layer.masksToBounds = true
        insertButton.addTarget(self, action: #selector(insertDataTarget), for: .touchUpInside)
        
        self.view.insertSubview(insertButton, aboveSubview: self.tableView)
        insertButton.translatesAutoresizingMaskIntoConstraints = false
        insertButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        insertButton.widthAnchor.constraint(equalToConstant: SCREEN_W*0.16).isActive = true
        insertButton.heightAnchor.constraint(equalToConstant: SCREEN_W*0.16).isActive = true
        insertButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -SCREEN_W*0.1).isActive = true
    }
    
    @objc func insertDataTarget() -> Void {
        
        self.navigationController?.pushViewController(DNEditorViewController(), animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DNDataManager.manager.selectAllData().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = DNDataManager.manager.selectAllData()[indexPath.section]
        var cell = tableView.dequeueReusableCell(withIdentifier: "DNNoteCellSwift") as? DNNoteCellSwift
        if cell == nil {
            cell = DNNoteCellSwift(style: .default, reuseIdentifier: "DNNoteCellSwift")
        }
        cell!.selectionStyle = .none
        cell!.setModel(model: model as! DNNoteModelSwift)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = DNDataManager.manager.selectAllData()[indexPath.section]
        let updateVc = DNDetailViewController()
        updateVc.model = model as? DNNoteModelSwift
        self.navigationController?.pushViewController(updateVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .default, title: "删除") { (deleteRowAction, index) in
            
            let model = DNDataManager.manager.selectAllData()[index.section]
            DNDataManager.manager.deleteData(uid: model.user_fmdb_id!)
            self.tableView.reloadData()
        }
        return [deleteAction]
    }
}
