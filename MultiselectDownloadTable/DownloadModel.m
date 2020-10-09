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
    }
    return self;
}
@end
