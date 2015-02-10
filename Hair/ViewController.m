//
//  ViewController.m
//  Hair
//
//  Created by 琦张 on 14/12/8.
//  Copyright (c) 2014年 zhphy. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "PhotoViewCell.h"
#import "HairDetailViewController.h"
#import "HairService.h"
#import "XBPickerViewController.h"
#import "HairStyleModel.h"
#import "HairStyleDao.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,PhotoViewCellDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) XBPickerViewController *pickerController;
@property (nonatomic, strong) NSArray *tags;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"美发博物馆"];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.selectButton setTitle:@"筛选" forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectButton];
    
    [self.view addSubview:self.tableView];
    
    [self requestTagList];
    
    [self requestStyleList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)requestTagList
{
    __weak typeof(self) weakSelf = self;
    [HairService getTagListsuccessBlock:^(NSDictionary *dictRet) {
        if (![[[dictRet objectForKey:@"data"] objectForKey:@"utime"] isEqualToString:@"0"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[dictRet objectForKey:@"data"] objectForKey:@"utime"] forKey:STRUCT_REFRESH_TIME];
            [[NSUserDefaults standardUserDefaults] setObject:[[dictRet objectForKey:@"data"] objectForKey:@"list"] forKey:STRUCT_DATA];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        weakSelf.tags = [[NSUserDefaults standardUserDefaults] objectForKey:STRUCT_DATA];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)requestStyleList
{
    __weak typeof(self) weakSelf = self;
    
    NSString *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:STYLE_REFRESH_TIME];
    if (!lastUpdateTime)
    {
        lastUpdateTime = @"0";
    }
    
    [HairService getHairListWithLastUpdateTime:lastUpdateTime successBlock:^(NSDictionary *dictRet) {
        
        if (![[[dictRet objectForKey:@"data"] objectForKey:@"utime"] isEqualToString:lastUpdateTime])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[[dictRet objectForKey:@"data"] objectForKey:@"utime"] forKey:STYLE_REFRESH_TIME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [HairStyleDao clearAllHairStyles];

            NSArray *array = [[dictRet objectForKey:@"data"] objectForKey:@"list"];
            static int count = 0;
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"del"] integerValue] == 0) {
                    HairStyleModel *model = [[HairStyleModel alloc] initWithDict:dict];
                    [model save];
                    [weakSelf.photoArray addObject:model];
                    count++;
                }
            }
        }else{
            weakSelf.photoArray = [HairStyleDao getAllHairStyles];
        }
        [weakSelf.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)showPickerView:(UIButton *)sender
{
    if (!_pickerController) {
        self.pickerController = [XBPickerViewController pickerViewController];
    }
    
    _pickerController.titles = self.tags;
    [_pickerController showInViewController:self];
}

#pragma mark -- Getter

- (UITableView *)tableView
{
    CGRect tableViewFrame = self.view.bounds;
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
        _tableView.tableFooterView = footView;
    }
    return _tableView;
}

- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil(self.photoArray.count/3.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"PhotoViewCell";
    
    PhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[PhotoViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSIndexSet *indexSet = nil;
    if ((indexPath.row + 1) * 3 < self.photoArray.count) {
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3*indexPath.row, 3)];
    }else{
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3*indexPath.row, self.photoArray.count - 3*indexPath.row)];
    }
    
    NSArray *array = [self.photoArray objectsAtIndexes:indexSet];
    cell.delegate = self;
    cell.object = array;
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 800*(self.view.width - 40)/3/480 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - PhotoViewCellDelegate
- (void)didSelectedPhotoViewCellIndex:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    HairStyleModel *model = [self.photoArray objectAtIndex:3*indexPath.row + index];
    NSString *hairImageUrl = model.mtFilePath;
    NSString *styleImageUrl = model.filePath;
    HairDetailViewController *detail = [[HairDetailViewController alloc] initWithDetailUrl:hairImageUrl andStyleUrl:styleImageUrl];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
