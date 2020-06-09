//
//  DNAudioManager.m
//  DNFMDBNote
//
//  Created by zjs on 2020/6/8.
//  Copyright © 2020 zjs. All rights reserved.
//

#import "DNAudioManager.h"

#import "lame.h"

#import <AVFoundation/AVFoundation.h>

#define FILEPATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audio.caf"]
#define PLAYPATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audio.mp3"]

static DNAudioManager *_manager = nil;

@interface DNAudioManager ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) void(^handler)(NSString *timeLong, NSData *audioData);
/// 音频时长
@property (nonatomic, assign) int timeNum;
@property (nonatomic,   copy) NSString *timeLong;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer   *audioPlayer;
@end

@implementation DNAudioManager

+ (instancetype)defaultManeger {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[self alloc] init];
        }
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [super allocWithZone:zone];
        }
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _manager;
}

- (void)dn_startRecordAudio:(void (^)(NSString * _Nonnull, NSData * _Nonnull))handler {
    
    self.handler = handler;
    /// 如果有进行的录音事件，则停止
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
    }
    /// 删除已有的录音文件
    [self deleteOldAudioFile];
    /// 创建录音会话
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                           error:&error];
    if (error) {
        NSLog(@"创建录音session出错: %@", error);
    }
    
    self.timeNum = 0;
    /// 首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    [self.audioRecorder record];
    [self calculateAudioTime];
}

- (void)dn_stopRecordAudio {
    /// 停止录音
    [self.audioRecorder stop];
    //终止定时器(如果没有终止方法,则定时器不会启动)
    dispatch_suspend(self.timer);
    /// 将 caf 音频文件转换成 MP3
    [self conversionFilesFormatMP3];
}

- (void)dn_playRecordAudio:(NSData *)audioData {
    
    NSError *playerErr;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playerErr];
    self.audioPlayer.volume = 1.0;
    if (self.audioPlayer == nil) {
        NSLog(@"ERror creating player: %@", [playerErr description]);
        return;
    } else {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        // 准备播放
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        NSLog(@"播放mp3成功！！！");
    }
}

/// 删除旧的 caf 音频文件
- (void)deleteOldAudioFile {
    
    BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:FILEPATH];
    
    if (!blHave) {
        NSLog(@"不存在");
        return;
    } else {
        BOOL blDele= [[NSFileManager defaultManager] removeItemAtPath:FILEPATH error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }
}

/// 计算音频文件时长（可能会少三秒）
- (void)calculateAudioTime {
    
    if (!self.timer) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    }
    
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    /** 设置定时器
     * para2: 任务开始时间
     * para3: 任务的间隔
     * para4: 可接受的误差时间，设置0即不允许出现误差
     * Tips : 单位均为纳秒
     */
    dispatch_source_set_timer(self.timer, start, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    /** 设置定时器任务
     * 可以通过block方式
     * 也可以通过C函数方式
     */
    dispatch_source_set_event_handler(self.timer, ^{
        
        self.timeNum++;
        NSLog(@"time: %d", self.timeNum);
        
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%.2d",self.timeNum/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%.2d",self.timeNum%60];
        
        self.timeLong = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];

        if(self.timeNum == 90) {
//            //终止定时器(如果没有终止方法,则定时器不会启动)
//            dispatch_suspend(self.timer);
            /// 停止录音
            [self dn_stopRecordAudio];
        }
    });
    //启动任务，GCD计时器创建后需要手动启动
    dispatch_resume(self.timer);
}

/// 将 caf 文件转换成 MP3
- (void)conversionFilesFormatMP3 {
    
    BOOL isExitMp3   = [[NSFileManager defaultManager] fileExistsAtPath:PLAYPATH];
    BOOL isRemoveMp3 = [[NSFileManager defaultManager] removeItemAtPath:PLAYPATH error:nil];
    if (isExitMp3) {
        if (isRemoveMp3) {
            NSLog(@"删除MP3成功！！！");
        }
    }
    @try {
        int read, write;
                
        //source 被转换的音频文件位置
        FILE *pcm = fopen([FILEPATH cStringUsingEncoding:1], "rb");

       
        if(pcm == NULL) {
            NSLog(@"file not found");
        } else {
            //skip file header
            fseek(pcm, 4*1024, SEEK_CUR);
            //output 输出生成的Mp3文件位置
            FILE *mp3 = fopen([PLAYPATH cStringUsingEncoding:1], "wb");
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
                if (read == 0) {
                     write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                    
                } else {
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                }
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
       }
    }
    @catch (NSException *exception) {
        NSLog ( @"%@" ,[exception description]);
    }
    @finally {
        
        NSData *audioData = [NSData dataWithContentsOfFile:PLAYPATH];
        self.handler(self.timeLong, audioData);
        NSLog(@"转换MP3成功！！！");
    }
}

#pragma mark -- Getter
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url = [NSURL URLWithString:FILEPATH];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url
                                                    settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error);
            return nil;
        }
    }
    return _audioRecorder;
}

- (NSDictionary *)getAudioSetting {
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                      forKey:AVFormatIDKey];
    //采样率
    [recordSettings setValue:[NSNumber numberWithFloat:11025.0]
                      forKey:AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue:[NSNumber numberWithInt:2]
                      forKey:AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin]
                      forKey:AVEncoderAudioQualityKey];
    
    return recordSettings;
}
@end
