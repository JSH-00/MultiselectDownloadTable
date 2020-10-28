//
//  DownloadModel.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/6.
//

#import "DownloadModel.h"

@implementation DownloadModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        [self changeToString];
    }
    return self;
}
- (void)changeToString
{
    self.create_time = [NSString stringWithFormat:@"%@",self.create_time];
    self.likes = [NSString stringWithFormat:@"%@",self.likes];
    self.shares = [NSString stringWithFormat:@"%@",self.shares];
    self.views = [NSString stringWithFormat:@"%@",self.views];
    self.create_time = [NSString stringWithFormat:@"%@",self.create_time];
    self.authorInfo = [NSString stringWithFormat:@"%@",self.authorInfo];
    self.duration = [NSString stringWithFormat:@"%@",self.duration];
    self.width = [NSString stringWithFormat:@"%@",self.width];
    self.height = [NSString stringWithFormat:@"%@",self.height];
    self.scene = [NSString stringWithFormat:@"%@",self.scene];
    self.sort = [NSString stringWithFormat:@"%@",self.sort];
    self.time_new = [NSString stringWithFormat:@"%@",self.time_new];
    self.create_time = [NSString stringWithFormat:@"%@",self.create_time];
}
+ (NSString *)primaryKey {
    return @"uniqueID";
}
+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"downloadTask",@"progress"];
}
@end
