//
//  MyTableViewCell.m
//  NetImage
//
//  Created by JSH on 2020/8/24.
//  Copyright © 2020 JSH. All rights reserved.
//

#import "MyTableViewCell.h"
#import <Masonry/Masonry.h>


@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化视图对象
        // 图片
        _bookImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_bookImageView];
        [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(4); //with is an optional semantic filler
            make.left.equalTo(self.mas_left).with.offset(6);
            make.bottom.equalTo(self.mas_bottom).with.offset(-4);
            make.right.equalTo(self.mas_right).with.offset(-6);
        }];
        
        _bookImageView.clipsToBounds = YES;
        _bookImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bookImageView.clipsToBounds = YES;
        _bookImageView.layer.cornerRadius = 6;
        // 添加到父视图
        // 自定义cell的时候, 所有视图都添加到cell的contentView中
        
        // 书名
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 20)];
        [self.contentView addSubview:_nameLabel];
        
        // 价格
        _prcieLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 200, 20)];
        [self.contentView addSubview:_prcieLabel];
        
        // 描述
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 200, 20)];
        [self.contentView addSubview:_descLabel];
        
        UIButton *share_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton = share_btn;
        [share_btn setBackgroundImage:[UIImage imageNamed:@"home_share.png" ]forState:UIControlStateNormal];
        [share_btn setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:share_btn];
        share_btn.backgroundColor = [UIColor clearColor];
        [share_btn setTitle:@"Back" forState:UIControlStateNormal];
        [share_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.top.equalTo(_bookImageView.mas_top).with.offset(169); //with is an optional semantic filler
            make.left.equalTo(_bookImageView.mas_left).with.offset(328);
            //            make.bottom.equalTo(_bookImageView.mas_bottom).with.offset(-14);
            //            make.right.equalTo(_bookImageView.mas_right).with.offset(-17);
        }];
    }
    return self;
}

// 自定义Cell中显示数据的方法
- (void)config:(Student *)model
{
    [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"small_one.png"]];
    self.nameLabel.text = model.author;
//    self.prcieLabel.text = [self transToTime:[NSString stringWithFormat:@"%@",model.create_time]];
    self.prcieLabel.text = model.time_new;
    self.descLabel.text = model.type;
    self.backgroundColor = [UIColor blackColor];
}

//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)transToTime:(NSString *)timeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    NSTimeInterval time =[timeStamp doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    return [formatter stringFromDate:detaildate];
}

@end
