//
//  DNNoteModel.m
//  DNFMDBNote
//
//  Created by zjs on 2018/7/13.
//  Copyright © 2018年 zjs. All rights reserved.
//

#import "DNNoteModel.h"

@implementation DNNoteModel

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeInt:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.timeDate forKey:@"timeDate"];
    [aCoder encodeObject:self.dayDate forKey:@"dayDate"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.user_id = [aDecoder decodeIntForKey:@"user_id"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.dayDate = [aDecoder decodeObjectForKey:@"dayDate"];
        self.timeDate = [aDecoder decodeObjectForKey:@"timeDate"];
    }
    return self;
}

@end
