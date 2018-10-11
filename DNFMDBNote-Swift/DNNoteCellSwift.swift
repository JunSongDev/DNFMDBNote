//
//  DNNoteCellSwift.swift
//  DNFMDBNote-Swift
//
//  Created by zjs on 2018/10/11.
//  Copyright © 2018 zjs. All rights reserved.
//

import UIKit

class DNNoteCellSwift: UITableViewCell {

    var content_label: UILabel?
    var dayDate_label: UILabel?
    var dayTime_label: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setSubviewsForSuper()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(model: DNNoteModelSwift) -> Void {
        
        self.content_label?.text = model.content
        self.dayDate_label?.text = model.dayDate
        self.dayTime_label?.text = model.timeDate
    }
    
    private func setSubviewsForSuper() -> Void {
        
        self.content_label = UILabel()
        self.content_label?.numberOfLines = 0
        
        self.dayDate_label = UILabel()
        self.dayDate_label?.textColor = .lightGray
        
        self.dayTime_label = UILabel()
        self.dayTime_label?.textColor = .lightGray
        
        self.contentView.addSubview(self.content_label!)
        self.contentView.addSubview(self.dayDate_label!)
        self.contentView.addSubview(self.dayTime_label!)
        
        self.content_label?.translatesAutoresizingMaskIntoConstraints = false
        self.dayDate_label?.translatesAutoresizingMaskIntoConstraints = false
        self.dayTime_label?.translatesAutoresizingMaskIntoConstraints = false
        
        self.content_label?.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
        self.content_label?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        self.content_label?.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        
        self.dayDate_label?.topAnchor.constraint(equalTo: self.content_label!.bottomAnchor, constant: 8).isActive = true
        self.dayDate_label?.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        self.dayDate_label?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
        
        self.dayTime_label?.topAnchor.constraint(equalTo: self.content_label!.bottomAnchor, constant: 8).isActive = true
        self.dayTime_label?.leftAnchor.constraint(equalTo: self.dayDate_label!.rightAnchor, constant: 8).isActive = true
        self.dayTime_label?.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
    }
}
