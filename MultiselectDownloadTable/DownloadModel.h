//
//  DownloadModel.h
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/6.
//

#import <Realm/Realm.h>
#import "ZZDownloadTask.h"

@interface DownloadModel : RLMObject
@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSString* download;
@property (nonatomic, strong) NSString* create_time;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* link;
@property (nonatomic, strong) NSString* likes;
@property (nonatomic, strong) NSString* shares;
@property (nonatomic, strong) NSString* views;
@property (nonatomic, strong) NSString* authorInfo;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* width;
@property (nonatomic, strong) NSString* height;
@property (nonatomic, strong) NSString* scene;
@property (nonatomic, strong) NSString* sort;
@property (nonatomic, strong) NSString* time_new;
@property (nonatomic, strong) ZZDownloadTask *downloadTask;
@property (nonatomic, assign) double progress;
@property BOOL alreadyDownloaded;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

RLM_ARRAY_TYPE(DownloadModel)
