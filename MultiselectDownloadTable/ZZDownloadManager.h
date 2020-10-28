//
//  ZZDownloadManager.h
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "DownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZDownloadManager : NSObject
@property (nonatomic, assign) double downloadProgress;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadSessionTask;
@property (nonatomic, strong) ZZDownloadTask * DownloadTask;
@property (nonatomic, assign) NSInteger  maxDownloadNum;
@property (nonatomic, strong) AFURLSessionManager *manager;
@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, strong) dispatch_semaphore_t semaphore;

- (void)downloadFromZZDownloadTaskArray:(NSArray <DownloadModel *> *)zzDownloadTaskArray andMaxDownloadNum:(NSInteger)maxDownloadNum;
@end

NS_ASSUME_NONNULL_END
