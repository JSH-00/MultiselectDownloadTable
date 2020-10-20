//
//  Student.h
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/19.
//

#import <Realm/Realm.h>
#import "ZZDownloadTask.h"
#import "DownloadModel.h"
@interface DownloadRealmModel : RLMObject
@property NSString* imageURL;
@property NSString* RLMid;
@property NSString* type;
@property NSString* thumbnail;
@property NSString* download;
@property NSString* create_time;
@property NSString* author;
@property NSString*  link;
@property NSString* likes;
@property NSString* shares;
@property NSString* views;
@property NSString* authorInfo;
@property NSString* duration;
@property NSString* width;
@property NSString* height;
@property NSString* scene;
@property NSString* sort;
@property NSString* time_new;
@property NSString *urlString;
@property double progress;
@property NSString *uniqueID;
@property BOOL alreadyDownloaded;
- (void)initWithDownloadMode:(DownloadModel *)downloadMode;
@end

RLM_ARRAY_TYPE(Student)
