//
//  DetailViewController.h
//  NetImage
//
//  Created by JSH on 2020/8/24.
//  Copyright © 2020 JSH. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Student * stu;
- (void)setSelectedStudent:(Student *)student;
- (NSString *)transToTime;
@end

NS_ASSUME_NONNULL_END
