//
//  DetailViewController.m
//  NetImage
//
//  Created by JSH on 2020/8/24.
//  Copyright © 2020 JSH. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/SDWebImage.h>


@interface DetailViewController ()
@property  (nonatomic, weak) UIButton *popBackBtn;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏NavigateBar
    // Do any additional setup after loading the view.
    // 图片
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 110, 100, 100)];
    // 添加到父视图
    // 自定义cell的时候, 所有视图都添加到cell的contentView中
    [self.view addSubview:bookImageView];
    
    // 书名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 105, 200, 20)];
    [self.view addSubview:nameLabel];
    
    // 价格
    UILabel * prcieLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 130, 200, 20)];
    [self.view addSubview:prcieLabel];
    
    // 描述
    UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 155, 200, 100)];
    [self.view addSubview:descLabel];
//    descLabel.textAlignment = NSTextAlignmentCenter;
    // 多行显示
    descLabel.numberOfLines=0;
    descLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bookImageView sd_setImageWithURL:[NSURL URLWithString:_stu.thumbnail]
                            placeholderImage:[UIImage imageNamed:@"small_two.png"]];
    nameLabel.text = _stu.author;
    prcieLabel.text = _stu.time_new;
    descLabel.text = [NSString stringWithFormat:@"width: %@",_stu.width];
    UIButton * back_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [back_btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:back_btn];
    [back_btn setTitle:@"Back" forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backVc) forControlEvents:UIControlEventTouchUpInside];
    [back_btn setFrame:CGRectMake(20, 20, 100, 50)];

}

- (void)setSelectedStudent:(Student *)student {
    _stu = student;
}

- (void)backVc
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
