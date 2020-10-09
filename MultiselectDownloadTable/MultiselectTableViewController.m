//
//  MultiselectTableViewController.m
//  MultiselectDownloadTable
//
//  Created by JSH on 2020/10/5.
//

#import "MultiselectTableViewController.h"
#import "MultiselectTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "DownloadModel.h"
@interface MultiselectTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic ,weak) UITableView * multiselectTable;
@property (nonatomic, weak)UIView * topView;
@property (nonatomic ,strong)NSMutableArray<DownloadModel *>*multiselectArray;
@property (nonatomic, weak) UIButton * selectBtn;
@property (nonatomic, weak) UIButton * downloadButton;
@property (nonatomic, assign)BOOL isSelectStyle;
- (void)reloadStudentList;
- (void)downloadFromURL:(NSString *)downloadURL;
@end

@implementation MultiselectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadStudentList];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏NavigateBar
    
    UITableView * multiselectTable = [UITableView new];
    [multiselectTable registerClass:[MultiselectTableViewCell class] forCellReuseIdentifier:@"PhotoCell"];// 注册 GestureTableViewCell
    
    self.multiselectTable = multiselectTable;
    self.multiselectTable.delegate = self;
    self.multiselectTable.dataSource = self;
    multiselectTable.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    multiselectTable.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:multiselectTable];
    
    UIView * topView = [UIView new];
    self.topView = topView;
    topView.frame = CGRectMake(0, 0, 375, 64);
    topView.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:1/1.0];
    [self.view addSubview:topView];
    
    UIButton *select_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = select_btn;
    self.isSelectStyle = NO;
    [self.view addSubview:select_btn];
    [select_btn addTarget:self action:@selector(selectButton) forControlEvents:UIControlEventTouchUpInside];
    select_btn.frame = CGRectMake(70, 31, 50 ,22);
    [select_btn setTitle:@"多选" forState:UIControlStateNormal];
    select_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadButton = downloadButton;
    [self.view addSubview:downloadButton];
    [downloadButton addTarget:self action:@selector(downloadSelectButton) forControlEvents:UIControlEventTouchUpInside];
    downloadButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 120, 31, 50, 22);
    [downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    downloadButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    NSLog(@"sandbox:%@",NSHomeDirectory());
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
    [[self.multiselectTable indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [insets addIndex:obj.row]; // 枚举方法遍历，拿到所选择的行号，存入索引中
    }];
    for (int i = 0; i < selecedArray.count; i++)
    {
        [self downloadFromURL:[selecedArray objectAtIndex:i].download];
    }
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
- (void)reloadStudentList
{
    self.multiselectArray = [NSMutableArray new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; //指定接收信号为image/png
    [manager GET:@"https://zerozerorobotics.com/api/v1/showcase/no-scene.json?skip=0&take=5" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        NSMutableArray * candyDictionaryArray = responseObject; //返回为Array类型
        for (int i = 0 ; i < candyDictionaryArray.count ; i++)
        {
            DownloadModel *sut = [[DownloadModel alloc] initWithDictionary:[candyDictionaryArray objectAtIndex:i]];
            [self.multiselectArray addObject:sut];
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
    NSLog(@"%@",downloadURL);
}
@end
