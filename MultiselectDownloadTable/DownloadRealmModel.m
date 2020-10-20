//
//  Student.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/19.
//

#import "DownloadRealmModel.h"

@implementation DownloadRealmModel
- (void)initWithDownloadMode:(DownloadModel *)downloadMode
{
    _imageURL = downloadMode.thumbnail;
    _RLMid = downloadMode.id;
    _type = downloadMode.type;
    _download = downloadMode.download;
    _thumbnail = downloadMode.thumbnail;
    _create_time = downloadMode.create_time;
    _author = downloadMode.author;
    _link = downloadMode.link;
    _likes = downloadMode.likes;
    _shares = downloadMode.shares;
    _views = downloadMode.views;
    _authorInfo = downloadMode.authorInfo;
    _duration = downloadMode.duration;
    _width = downloadMode.width;
    _height = downloadMode.height;
    _scene = downloadMode.scene;
    _sort = downloadMode.sort;
    _time_new = downloadMode.time_new;
    _urlString = downloadMode.downloadTask.urlString;
    _progress = downloadMode.downloadTask.progress;
    _uniqueID = downloadMode.downloadTask.uniqueID;
    _alreadyDownloaded = downloadMode.downloadTask.alreadyDownloaded;
}

+ (NSString *)primaryKey {
    return @"uniqueID";
}
@end
