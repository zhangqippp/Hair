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

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}

@property (nonatomic, strong) UICollectionView *collectionView;
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
    
    [self.view addSubview:self.collectionView];
    
    //下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectionView;
    header.delegate = self;

    [header beginRefreshing];
    _header = header;
    
    //下拉刷新
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectionView;
    footer.delegate = self;
    _footer = footer;
    
    __weak typeof(self) weakSelf = self;
    [HairService getTagListsuccessBlock:^(NSDictionary *dictRet) {
        [[NSUserDefaults standardUserDefaults] setObject:[dictRet objectForKey:@"data"] forKey:@"data"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        weakSelf.tags = [[dictRet objectForKey:@"data"] objectForKey:@"list"];
        NSLog(@"!!!!!%@",weakSelf.tags)
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)dealloc
{
    [_header free];
    [_footer free];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPickerView:(UIButton *)sender
{
    if (!_pickerController) {
        self.pickerController = [XBPickerViewController pickerViewController];
    }
    
    _pickerController.titles = self.tags;
    [_pickerController showInViewController:self];
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectionView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 刷新控件的代理方法
#pragma mark 开始进入刷新状态
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----开始进入刷新状态", refreshView.class);
    
    _count = _count+12;
    // 2.2秒后刷新表格UI
    [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
}

#pragma mark 刷新完毕
- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"%@----刷新完毕", refreshView.class);
}

#pragma mark 监听刷新状态的改变
- (void)refreshView:(MJRefreshBaseView *)refreshView stateChange:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateNormal:
            NSLog(@"%@----切换到：普通状态", refreshView.class);
            break;
            
        case MJRefreshStatePulling:
            NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
            break;
            
        case MJRefreshStateRefreshing:
            NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
            break;
        default:
            break;
    }
}

#pragma mark -- Getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        [self.collectionView registerClass:[PhotoViewCell class]
                forCellWithReuseIdentifier:@"Cell"];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
        for (NSInteger i=1; i<15; i++) {
            NSString *imageName = [NSString stringWithFormat:@"hair%ld",(long)i];
            [_photoArray addObject:imageName];
        }
    }
    return _photoArray;
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.photoImg.image = [UIImage imageNamed:[self.photoArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {10,10,10,10};
    return top;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.view.width - 40)/3,800*(self.view.width - 40)/3/480);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *hairImage = [UIImage imageNamed:[self.photoArray objectAtIndex:indexPath.row]];
    UIImage *styleImage = [UIImage imageNamed:[self.photoArray objectAtIndex:indexPath.row]];
    HairDetailViewController *detail = [[HairDetailViewController alloc] initWithDetailImage:hairImage andStyleImage:styleImage];
    [self.navigationController pushViewController:detail animated:YES];
}


@end
