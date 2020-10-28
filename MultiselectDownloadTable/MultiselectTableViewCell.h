//
//  MultiselectTableViewCell.h
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/6.
//

#import <UIKit/UIKit.h>
#import "DownloadModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MultiselectTableViewCell : UITableViewCell
@property (nonatomic, weak) UIImageView * downloadThumbnail;
@property (nonatomic, weak) NSString *cellTaskID;
@property (nonatomic, weak) UILabel *downloadLabel;
@property (nonatomic, weak) UIProgressView *downloadPregress;
- (void)setCellInfo:(DownloadModel *)downloadModel;
@end

NS_ASSUME_NONNULL_END
