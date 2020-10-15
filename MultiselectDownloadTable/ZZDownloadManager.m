//
//  ZZDownloadManager.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/13.
//

#import "ZZDownloadManager.h"

@implementation ZZDownloadManager
- (void)downloadFromZZDownloadTaskArray:(NSArray <DownloadModel *> *)zzDownloadTaskArray andMaxDownloadNum:(NSInteger)maxDownloadNum
{
    /* 开始请求下载 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.manager = manager;
    self.maxDownloadNum = &(maxDownloadNum);
    dispatch_queue_t que = dispatch_queue_create("com.vc.downloadQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(*(self.maxDownloadNum));
    self.queue = que;
    self.semaphore = semaphore;
    [zzDownloadTaskArray enumerateObjectsUsingBlock:^(DownloadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(que, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [self downloadFromURL:[zzDownloadTaskArray objectAtIndex:idx].download andDownloadModel:[zzDownloadTaskArray objectAtIndex:idx]];
        });
    }];
}

- (void)downloadFromURL:(NSString *)downloadURL andDownloadModel:(DownloadModel *)downloadModel
{
    NSURL *url = [NSURL URLWithString:downloadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    /* 下载路径创建，指定下载到沙盒Documents/Announcement文件夹中 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Announcement"];
    [self createNewFolder:path];
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];

    self.downloadSessionTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％，线程：%@", downloadProgress.fractionCompleted * 100, [NSThread currentThread]);

        dispatch_async(dispatch_get_main_queue(), ^{
            //进行UI操作，需要切换到主线
            double progress = downloadProgress.fractionCompleted;
            downloadModel.downloadTask.progress = progress;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Download_Progress_Update" object:downloadModel];
        });

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        dispatch_semaphore_signal(self.semaphore);
        [[[UIAlertView alloc] initWithTitle:@"下载完成" message:self.downloadSessionTask.response.suggestedFilename delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    }];
    [self.downloadSessionTask resume];
}

- (void)createNewFolder:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
@end
