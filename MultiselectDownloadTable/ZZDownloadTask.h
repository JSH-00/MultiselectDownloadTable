//
//  ZZDownloadTask.h
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZDownloadTask : NSObject
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) double progress;
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, assign) BOOL alreadyDownloaded;
@end

NS_ASSUME_NONNULL_END
