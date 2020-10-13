//
//  MultiselectTableViewController.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/5.
//
#import "Masonry.h"
#import "MultiselectTableViewController.h"
#import "MultiselectTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "DownloadModel.h"
#import "ZZDownloadTask.h"

@interface MultiselectTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic ,weak) UITableView * multiselectTable;
@property (nonatomic, weak)UIView * topView;
@property (nonatomic ,strong)NSMutableArray<DownloadModel *>*multiselectArray;
@property (nonatomic, weak) UIButton * selectBtn;
@property (nonatomic, weak) UIButton * downloadButton;
@property (nonatomic, assign)BOOL isSelectStyle;
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic, strong) NSURLSession* session;
- (void)reloadDownloadList;
- (void)downloadFromURL:(NSString *)downloadURL;
@end

@implementation MultiselectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadDownloadList];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏NavigateBar
    
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
    [selecedArray enumerateObjectsUsingBlock:^(DownloadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self downloadFromURL:[selecedArray objectAtIndex:idx].download];
    }];
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
        for (int i = 0 ; i < candyDictionaryArray.count ; i++)
        {
            DownloadModel *downloadModelInfo = [[DownloadModel alloc] initWithDictionary:[candyDictionaryArray objectAtIndex:i]];
            downloadModelInfo.downloadTask = [[ZZDownloadTask alloc] init];
            downloadModelInfo.downloadTask.urlString = downloadModelInfo.download;
            downloadModelInfo.downloadTask.progress = 0.0;
            downloadModelInfo.downloadTask.uniqueID = [NSString stringWithFormat:@"task%d",i];
            downloadModelInfo.downloadTask.alreadyDownloaded = NO;
            [self.multiselectArray addObject:downloadModelInfo];
        }
        [self.multiselectTable reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        NSLog(@"%@",error);
    }];
    [self.multiselectTable reloadData];
}

# pragma mark - Download From URL
- (void)downloadFromURL:(NSString *)downloadURL
{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:downloadURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    /* 下载路径创建，指定下载到沙盒Documents/Announcement文件夹中 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Announcement"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDir && existed)) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [path stringByAppendingPathComponent:url.lastPathComponent];

    /* 开始请求下载 */
    self.downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度：%.0f％，线程：%@", downloadProgress.fractionCompleted * 100, [NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //进行UI操作，需要切换到主线
            NSURL *url =  request.URL;
            NSString *urlString = [url absoluteString];
            __block DownloadModel * currentModel = nil;
            [self.multiselectArray enumerateObjectsUsingBlock:^(DownloadModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([urlString isEqualToString:obj.download]) {
                    currentModel = obj;
                    *stop = YES;
                }
            }];
            double progress = downloadProgress.fractionCompleted;
            currentModel.downloadTask.progress = progress;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Download_Progress_Update" object:currentModel];
        });

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {

        return [NSURL fileURLWithPath:filePath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[[UIAlertView alloc] initWithTitle:@"下载完成" message:self.downloadTask.response.suggestedFilename delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil] show];
    }];
    [self.downloadTask resume];
}
@end
