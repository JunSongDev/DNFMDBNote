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
@property (nonatomic,   copy) NSString * titleStr;
@property (nonatomic,   copy) NSString * content;
@property (nonatomic,   copy) NSString * dateStr;
@property (nonatomic, strong) NSData   * imageData;
@property (nonatomic, strong) NSData   * audioData;
@end
