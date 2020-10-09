//
//  TableViewController.m
//  NetImage
//
//  Created by JSH on 2020/8/24.
//  Copyright © 2020 JSH. All rights reserved.
//

#import "TableViewController.h"
#import "Student.h"
#import "MyTableViewCell.h"
#import "DetailViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * multiselectArray;
@property (nonatomic, strong) NSMutableDictionary * myDictonaryData;
@property (nonatomic, weak) UIView * topView;
@property (nonatomic, weak) UILabel * topTextLabel;
@property (nonatomic, strong) UITableView * multiselectTable;
@property (nonatomic, weak) UIButton * selectBtn;
@property (nonatomic, weak) UIButton * editorBtn;
@property (nonatomic, weak) UIButton * insertBtn;
@property (nonatomic, assign)BOOL isSelectStyle;
@property (nonatomic, assign)BOOL isDeleteStyle;
@property (nonatomic, assign)BOOL isInsertStyle;
@property (nonatomic, weak) UIButton * deleteSelectBtn;

- (void)reloadStudentList;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadStudentList];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏NavigateBar
    
    UIView *top_view = [[UIView alloc] init];
    self.topView = top_view;
    top_view.frame = CGRectMake(0, 0, 375, 64);
    top_view.backgroundColor = [UIColor colorWithRed:18/255.0 green:18/255.0 blue:18/255.0 alpha:1/1.0];
    [self.view addSubview:top_view];
    
    UIButton *select_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn = select_btn;
    self.isSelectStyle = NO;
    [self.view  addSubview:select_btn];
    [select_btn addTarget:self action:@selector(selectButton) forControlEvents:UIControlEventTouchUpInside];
    select_btn.frame = CGRectMake(100, 31, 50 ,22);
    [select_btn setTitle:@"多选" forState:UIControlStateNormal];
    select_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    
    UIButton *delete_select_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteSelectBtn = delete_select_btn;
    self.isSelectStyle = NO;
    [self.view  addSubview:delete_select_btn];
    [delete_select_btn addTarget:self action:@selector(deleteSelectButton) forControlEvents:UIControlEventTouchUpInside];
    delete_select_btn.frame = CGRectMake(2, 31, 100 ,22);
    [delete_select_btn setTitle:@"删除多个" forState:UIControlStateNormal];
    delete_select_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [self.deleteSelectBtn setHidden:YES];

    
    UILabel *top_text_label = [[UILabel alloc] init];
    self.topTextLabel = top_text_label;
    top_text_label.frame = CGRectMake(172, 31, 32, 22);
    top_text_label.text = @"发现";
    top_text_label.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    top_text_label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    [self.view addSubview:top_text_label];
    
    UIButton *editor_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editorBtn = editor_btn;
    self.isDeleteStyle = NO;
    [self.view  addSubview:editor_btn];
    [editor_btn addTarget:self action:@selector(editorButton) forControlEvents:UIControlEventTouchUpInside];
    editor_btn.frame = CGRectMake(300, 31, 50 ,22);
    [editor_btn setTitle:@"删除" forState:UIControlStateNormal];
    editor_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    
    UIButton *insert_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.insertBtn = insert_btn;
    self.isInsertStyle = NO;
    [self.view  addSubview:insert_btn];
    [insert_btn addTarget:self action:@selector(insertViewBtn) forControlEvents:UIControlEventTouchUpInside];
    insert_btn.frame = CGRectMake(240, 31, 50 ,22);
    [insert_btn setTitle:@"插入" forState:UIControlStateNormal];
    insert_btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];

    UITableView *view = [UITableView new];
    self.multiselectTable = view;
    view.dataSource = self;
    view.delegate = self;
    view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
}

// 这个方法返回对应的section有多少个元素，也就是多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.multiselectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [cell config:self.multiselectArray[indexPath.row]];
    // cell 选中时无效果
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    cell.userInteractionEnabled=YES;
    self.multiselectTable.allowsSelectionDuringEditing=YES;
    cell.tintColor = [UIColor redColor];
    //    cell.accessoryType = UITableViewCellAccessoryNone;//cell没有任何的样式
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；
    //    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;//cell右边有一个蓝色的圆形button；
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;//cell右边的形状是对号；
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 207; // 设置cell 高度
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(self.isSelectStyle) // 如果是选择模式，则不进行跳转页面操作
    {
        return;
    }
}

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
            Student *sut = [[Student alloc] initWithDictionary:[candyDictionaryArray objectAtIndex:i]];
            sut.time_new = [self formattTimeStringWith:sut.create_time];
            [self.multiselectArray addObject:sut];
        }
        
        [self.multiselectTable reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        NSLog(@"%@",error);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 右滑删除操作
// 判断某行是否可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

// 返回删除模式icon
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.multiselectTable isEditing])
    {
        if (self.isInsertStyle)
        {
            return UITableViewCellEditingStyleInsert;
        }
        if(self.isDeleteStyle)
        {
            return UITableViewCellEditingStyleDelete;
        }
        if(self.isSelectStyle)
        {
            return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
        }
    }
    return 0;
}

// 删除按钮改为中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        [self.myArrayData removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationRight];
//    }
//
//    /** 点击 +号 图标的操作. */
//    else if (editingStyle == UITableViewCellEditingStyleInsert) { /**< 判断编辑状态是插入时. */
//        /** 1. 更新数据源:向数组中添加数据. */
//        [self.myArrayData insertObject:[self.myArrayData objectAtIndex:3] atIndex:indexPath.row];
//
//        /** 2. TableView中插入一个cell. */
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//    else if (editingStyle ==(UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert))
//    {
//        //插入数据，刷新界面
//        NSArray *deleteArr =[self.myTableView indexPathsForSelectedRows];
//        NSLog(@"%@",deleteArr);
//
//    }
}

- (void)selectButton
{
    if (self.isSelectStyle)
    {
        [self.selectBtn setTitle:@"多选" forState:UIControlStateNormal];
        self.isSelectStyle = NO;
        [self.multiselectTable setEditing:NO animated:NO];
        [self.deleteSelectBtn setHidden:YES];
        [self.editorBtn setHidden:NO];
        [self.insertBtn setHidden:NO];

    }
    else
    {
        [self.selectBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.isSelectStyle = YES; // 是否为删除/插入模式icon
        [self.multiselectTable setEditing:YES animated:NO];
        [self.deleteSelectBtn setHidden:NO];
        [self.editorBtn setHidden:YES];
        [self.insertBtn setHidden:YES];

    }
}

- (void)editorButton
{
    if (self.isDeleteStyle)
    {
        [self.editorBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.isDeleteStyle = NO;
        [self.multiselectTable setEditing:NO animated:NO];
        [self.insertBtn setHidden:NO];
        [self.selectBtn setHidden:NO];
    }
    else
    {
        [self.editorBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.isDeleteStyle = YES; // 是否为删除/插入模式icon
        [self.multiselectTable setEditing:YES animated:NO];
        [self.insertBtn setHidden:YES];
        [self.selectBtn setHidden:YES];
    }
}

- (void)insertViewBtn
{
    if (self.isInsertStyle)
    {
        [self.insertBtn setTitle:@"插入" forState:UIControlStateNormal];
        self.isInsertStyle = NO;
        [self.multiselectTable setEditing:NO animated:NO];
        [self.selectBtn setHidden:NO];
        [self.editorBtn setHidden:NO];
    }
    else
    {
        [self.insertBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.isInsertStyle = YES; // 是否为删除/插入模式icon
        [self.multiselectTable setEditing:YES animated:NO];
        [self.selectBtn setHidden:YES];
        [self.editorBtn setHidden:YES];
    }
}

- (void)deleteSelectButton
{
    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    [[self.multiselectTable indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [insets addIndex:obj.row]; // 枚举方法遍历，拿到所选择的行号,存入索引中
    }];
    [self.multiselectArray removeObjectsAtIndexes:insets];
    [self.multiselectTable deleteRowsAtIndexPaths:[self.multiselectTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];

}

//字符串转时间戳 如：2017-4-10 17:15:10
- (NSString *)formattTimeStringWith:(NSString *)timeStamp{
    NSLog(@"%s",__func__);
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:ss"];
    NSTimeInterval time =[timeStamp doubleValue];
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    return [formatter stringFromDate:detaildate];
}

@end
