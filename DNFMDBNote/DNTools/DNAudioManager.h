//
//  DNAudioManager.h
//  DNFMDBNote
//
//  Created by zjs on 2020/6/8.
//  Copyright © 2020 zjs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNAudioManager : NSObject

+ (instancetype)defaultManeger;

- (void)dn_startRecordAudio:(void(^)(NSString *timeLong, NSData *audioData))handler;
- (void)dn_stopRecordAudio;
- (void)dn_playRecordAudio:(NSData *)audioData;
@end

NS_ASSUME_NONNULL_END
