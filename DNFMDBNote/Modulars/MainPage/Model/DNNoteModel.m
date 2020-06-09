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
    
    [aCoder encodeInt:self.user_id      forKey:@"user_id"];
    [aCoder encodeObject:self.content   forKey:@"content"];
    [aCoder encodeObject:self.titleStr  forKey:@"titleStr"];
    [aCoder encodeObject:self.dateStr   forKey:@"dateStr"];
    [aCoder encodeObject:self.imageData forKey:@"imageData"];
    [aCoder encodeObject:self.audioData forKey:@"audioData"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.user_id   = [aDecoder decodeIntForKey:@"user_id"];
        self.content   = [aDecoder decodeObjectForKey:@"content"];
        self.titleStr  = [aDecoder decodeObjectForKey:@"titleStr"];
        self.dateStr   = [aDecoder decodeObjectForKey:@"dateStr"];
        self.imageData = [aDecoder decodeObjectForKey:@"imageData"];
        self.audioData = [aDecoder decodeObjectForKey:@"audioData"];
    }
    return self;
}

@end
