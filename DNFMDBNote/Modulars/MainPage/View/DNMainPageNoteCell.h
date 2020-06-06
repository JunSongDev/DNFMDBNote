//
//  DNMainPageNoteCell.h
//  DNFMDBNote
//
//  Created by zjs on 2020/6/6.
//  Copyright © 2020 zjs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DNNoteModel;
@interface DNMainPageNoteCell : UITableViewCell

@property (nonatomic, strong) DNNoteModel *model;
@end

NS_ASSUME_NONNULL_END
