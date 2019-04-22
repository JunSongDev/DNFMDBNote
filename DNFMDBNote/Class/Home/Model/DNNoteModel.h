//
//  DNNoteModel.h
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNBaseModel.h"

@interface DNNoteModel : DNBaseModel<NSCoding>


@property (nonatomic, assign) int modelID;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * dayDate;
@property (nonatomic, copy) NSString * timeDate;
@property (nonatomic, assign) NSData * imageData;
@end
