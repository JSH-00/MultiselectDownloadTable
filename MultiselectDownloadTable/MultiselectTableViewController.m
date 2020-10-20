//
//  MultiselectTableViewController.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/5.
//
#import "Masonry.h"
#import "MultiselectTableViewController.h"
#import "MultiselectTableViewCell.h"
#import "ZZDownloadTask.h"
#import "ZZDownloadManager.h"
#import "DownloadRealmModel.h"
@interface MultiselectTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView * multiselectTable;
@property (nonatomic, weak)UIView * topView;
@property (nonatomic, strong)NSMutableArray<DownloadModel *>*multiselectArray;
@property (nonatomic, weak) UIButton * selectBtn;
@property (nonatomic, weak) UIButton * downloadButton;
@property (nonatomic, assign)BOOL isSelectStyle;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic, strong) NSURLSession* session;
@property (nonatomic, assign) NSInteger maxDownloadNum;
- (void)reloadDownloadList;
@end

@implementation MultiselectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadDownloadList];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏NavigateBar
    NSLog(@"%@",NSHomeDirectory());
    UIView * topView = [UIView new];
    self.topView = topView;
    topView.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:1/1.0];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(64);
    }];

    UITableView * multiselectTable = [UITableView new];
    [multiselectTable registerClass:[MultiselectTableViewCell class] forCellReuseIdentifier:@"PhotoCell"];// 注册 GestureTableViewCell
    
    self.multiselectTable = multiselectTable;
    self.multiselectTable.delegate = self;
    self.multiselectTable.dataSource = self;
    multiselectTable.backgroundColor = [UIColor grayColor];
    [self.view addSubview:multiselectTable];
    [multiselectTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = selectBtn;
    self.isSelectStyle = NO;
    [self.view addSubview:selectBtn];
    [selectBtn addTarget:self action:@selector(selectButton) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitle:@"多选" forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).with.offset(15);
        make.left.equalTo(self.topView.mas_left).with.offset(45);
    }];
    
    UILabel * maxDownloadLabel = [UILabel new];
    maxDownloadLabel.text = @"最大下载数";
    maxDownloadLabel.textColor = [UIColor whiteColor];
    maxDownloadLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self.view addSubview:maxDownloadLabel];
    [maxDownloadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).with.offset(22);
        make.left.equalTo(self.topView.mas_left).with.offset(CGRectGetWidth(self.view.frame) * 0.5 - 85);
    }];

    NSInteger maxDownloadNum = 3;
    self.maxDownloadNum = maxDownloadNum;
    UITextField *maxDownloadTextField =  [UITextField new];
    maxDownloadTextField.borderStyle = UITextBorderStyleRoundedRect;
    maxDownloadTextField.backgroundColor = [UIColor whiteColor];
    maxDownloadTextField.text = [NSString stringWithFormat:@"%ld",(long)self.maxDownloadNum];
    maxDownloadTextField.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [maxDownloadTextField setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:maxDownloadTextField];
    [maxDownloadTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).with.offset(15);
        make.left.equalTo(self.topView.mas_left).with.offset(CGRectGetWidth(self.view.frame) * 0.5);
    }];
    [maxDownloadTextField addTarget:self
                   action:@selector(maxDownloadTextFieldDidChange:)
         forControlEvents:UIControlEventEditingChanged];

    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton = downloadButton;
    [self.view addSubview:downloadButton];
    [downloadButton addTarget:self action:@selector(downloadSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    downloadButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).with.offset(15);
        make.right.equalTo(self.topView.mas_right).with.offset(-45);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.multiselectArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
# pragma mark - setCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MultiselectTableViewCell *cell = [self.multiselectTable dequeueReusableCellWithIdentifier:@"PhotoCell"];
    if (nil == cell) {
        cell = [[MultiselectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PhotoCell"];
    }
    cell.backgroundColor = [UIColor blackColor];
    [cell setCellInfo:[self.multiselectArray objectAtIndex:indexPath.row]];
    self.multiselectTable.allowsSelection = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    cell.userInteractionEnabled = YES;
    self.multiselectTable.allowsSelectionDuringEditing = YES;
    return cell;
}
# pragma mark - selectBtn
- (void)selectButton
{
    if (self.isSelectStyle)
    {
        [self.selectBtn setTitle:@"多选" forState:UIControlStateNormal];
        self.isSelectStyle = NO;
        [self.multiselectTable setEditing:NO animated:NO];
    }
    else
    {
        [self.selectBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.isSelectStyle = YES; // 是否为删除/插入模式icon
        [self.multiselectTable setEditing:YES animated:NO];
    }
}

- (void)downloadSelectButton
{
    NSArray<DownloadModel *> *selecedArray = [NSMutableArray new];
    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    // 枚举方法遍历，拿到未下载的行号，存入索引中
    [[self.multiselectTable indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.multiselectArray objectAtIndex:obj.row].downloadTask.alreadyDownloaded == NO)
        {
            [insets addIndex:obj.row];
            [self.multiselectArray objectAtIndex:obj.row].downloadTask.alreadyDownloaded = YES;
        }
    }];
    selecedArray = [self.multiselectArray objectsAtIndexes:insets];
    ZZDownloadManager * zzDownloadManager = [ZZDownloadManager new];
    [zzDownloadManager downloadFromZZDownloadTaskArray:selecedArray andMaxDownloadNum:self.maxDownloadNum];
}

- (void) maxDownloadTextFieldDidChange:(UITextField*) sender {
    // 文本内容
    NSInteger times = [sender.text integerValue];
    self.maxDownloadNum = times;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark - 判断某行是否可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

# pragma mark - 返回删除模式icon
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.multiselectTable isEditing])
    {
        if(self.isSelectStyle)
        {
            return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
        }
    }
    return 0;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.multiselectArray removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self.multiselectArray insertObject:[self.multiselectArray objectAtIndex:3] atIndex:indexPath.row];

        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } else if (editingStyle == (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert))
    {
        NSLog(@"多选");
    }
}

# pragma mark - reloadList
- (void)reloadDownloadList
{
    self.multiselectArray = [NSMutableArray new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:@"https://zerozerorobotics.com/api/v1/showcase/no-scene.json?skip=0&take=10" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSMutableArray * candyDictionaryArray = responseObject; //返回为Array类型
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        for (int i = 0 ; i < candyDictionaryArray.count ; i++)
        {
            DownloadModel *downloadModelInfo = [[DownloadModel alloc] initWithDictionary:[candyDictionaryArray objectAtIndex:i]];
            downloadModelInfo.downloadTask = [[ZZDownloadTask alloc] init];
            downloadModelInfo.downloadTask.urlString = downloadModelInfo.download;
            downloadModelInfo.downloadTask.progress = 0.0;
            downloadModelInfo.downloadTask.uniqueID = [NSString stringWithFormat:@"task%d",i];
            downloadModelInfo.downloadTask.alreadyDownloaded = NO;
            DownloadRealmModel *downloadRealModelInfo = [DownloadRealmModel new];
            [downloadRealModelInfo initWithDownloadMode:downloadModelInfo];
            [realm addOrUpdateObject:downloadRealModelInfo];
            [self.multiselectArray addObject:downloadModelInfo];
        }
        [realm commitWriteTransaction];
        [self.multiselectTable reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        NSLog(@"%@",error);
    }];
    [self.multiselectTable reloadData];
}
@end
