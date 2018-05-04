//
//  GCMAssetModel.m
//  SelectMediumFile
//
//  Created by macavilang on 16/6/28.
//  Copyright © 2016年 Snoopy. All rights reserved.
//

#import "GCMAssetModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadImageTool.h"

@implementation GCMAssetModel

- (void)originalImage:(void (^)(UIImage *))returnImage{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:self.imageURL resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = asset.defaultRepresentation;
        CGImageRef imageRef = rep.fullResolutionImage;
        UIImage *image = [UIImage imageWithCGImage:imageRef scale:rep.scale orientation:(UIImageOrientation)rep.orientation];
        if (image) {
            returnImage(image);
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void) convertVideoWithModel:(GCMAssetModel *) model
{
 
    [self creatSandBoxFilePathIfNoExist];
    //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    model.sandboxPath = [videoPath stringByAppendingPathComponent:model.fileName];
    //转码配置
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:model.imageURL options:nil];
    
    //AVAssetExportPresetMediumQuality可以更改，是枚举类型，官方有提供，更改该值可以改变视频的压缩比例
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:model.sandboxPath];
    //AVFileTypeMPEG4 文件输出类型，可以更改，是枚举类型，官方有提供，更改该值也可以改变视频的压缩比例
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        NSLog(@"%d",exportStatus);
        switch (exportStatus)
        {
            case AVAssetExportSessionStatusFailed:
            {
                // log error to text view
                NSError *exportError = exportSession.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                [YGNetService dissmissLoadingView];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadVideofialure" object:nil userInfo:@{@"fialure":@"1"}];

                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"视频转码成功");
               UIImage *image = [self getImage:model.sandboxPath];
                NSData *data = [NSData dataWithContentsOfFile:model.sandboxPath];
                model.fileData = data;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadVideoSucces" object:nil userInfo:@{@"data":data,@"thumb":image}];
                    //删掉
                    [[NSFileManager defaultManager]removeItemAtPath:[exportSession.outputURL path] error:nil];
                break;
            }

        }
    }];
    
}

//缩略图
-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

- (void)creatSandBoxFilePathIfNoExist
{
    //沙盒路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSLog(@"databse--->%@",documentDirectory);
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //创建目录
    NSString *createPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileImage is exists.");
    }
}

@end
