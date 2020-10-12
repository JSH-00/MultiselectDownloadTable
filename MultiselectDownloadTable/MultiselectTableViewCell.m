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
}

- (void)progressUpdate:(NSNotification *)noti {
    DownloadModel *model = noti.object;

    if(model.downloadTask.uniqueID == self.cellTaskID)
    {
        [self.downloadLabel setText:[NSString stringWithFormat:@"%.2f%%",(model.downloadTask.progress * 100)]];
        self.downloadPregress.progress = model.downloadTask.progress;
        NSLog(@"progress:%f",model.downloadTask.progress);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressUpdate:) name:@"Download_Progress_Update" object:nil];
        UIProgressView *downloadPregress = [[UIProgressView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 250, 137 , 250, 15)];
        self.downloadPregress = downloadPregress;
        [self addSubview:downloadPregress];

        UILabel *downloadLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, 200, 30)];
        self.downloadLabel = downloadLable;
        downloadLable.textColor = [UIColor whiteColor];
        [self addSubview:downloadLable];
    }
    return self;
}

- (void)setCellInfo:(DownloadModel *)downloadModel
{
    [self.downloadThumbnail sd_setImageWithURL:[NSURL URLWithString:downloadModel.thumbnail]
                          placeholderImage:[UIImage imageNamed:@"loading.png"]];
    self.cellTaskID = downloadModel.downloadTask.uniqueID;
}

@end
