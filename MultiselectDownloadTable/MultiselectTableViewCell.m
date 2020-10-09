//
//  MultiselectTableViewCell.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/6.
//

#import "MultiselectTableViewCell.h"
#import <SDWebImage/SDWebImage.h>

@implementation MultiselectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier\
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView * downloadThumbnail = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 250, 18, 250, 117)];
        self.downloadThumbnail = downloadThumbnail;
        downloadThumbnail.layer.cornerRadius = 5;
        downloadThumbnail.layer.masksToBounds = YES;
        downloadThumbnail.backgroundColor = [UIColor redColor];
        downloadThumbnail.clipsToBounds = YES;
        downloadThumbnail.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:downloadThumbnail];
    }
    return self;
}

- (void)setCellInfo:(DownloadModel *)downloadModel
{
    [self.downloadThumbnail sd_setImageWithURL:[NSURL URLWithString:downloadModel.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"small_one.png"]];
}

@end
