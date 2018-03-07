//
//  ViewController.m
//  NoNetworkDemo
//
//  Created by 马清霞 on 2018/3/6.
//  Copyright © 2018年 Sherry. All rights reserved.
//

#import "ViewController.h"
#import "Masonry/Masonry.h"

#define ColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:a]


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_currentTabView;
    UIView *_tableHeaderView;
    UIView *_hintView;
    UISearchBar *_currentSearchBar;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initContentView];
    [self initNavigationItem];
}

- (void)initNavigationItem{
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"切换网络状态" style:UIBarButtonItemStylePlain target:self action:@selector(clickAction:)];
    rightBarItem.tag = 1;
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)initContentView {
    UITableView *tabView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _currentTabView = tabView;
    [tabView setContentInset:UIEdgeInsetsMake(-40, 0, 0, 0)];
    tabView.dataSource = self;
    tabView.delegate = self;
    [self.view addSubview:tabView];
    tabView.tableHeaderView = [self searchHintView];
//    tabView.tableHeaderView.hidden = YES;
}

#pragma mark - 开始动画和结束动画
//没有搜索栏是直接把提示语添加到headerview控制偏移量实现动画效果
- (void)startAnimation{
    _currentTabView.tableHeaderView.hidden = NO;
    [UIView animateWithDuration:.5 animations:^{
        [_currentTabView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
}

- (void)stopAnimation{
    [UIView animateWithDuration:.5 animations:^{
        [_currentTabView setContentInset:UIEdgeInsetsMake(-40, 0, 0, 0)];
    } completion:^(BOOL finished) {
        _currentTabView.tableHeaderView.hidden = YES;
    }];
}


#pragma mark - 有搜索框是执行的动画
//仅仅是修改headerview高度以及提示语那一栏的高度
- (void)startSearchHintAnimation{
    [UIView animateWithDuration:.5 animations:^{
        _tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
        _hintView.frame = CGRectMake(0, 40, self.view.frame.size.width, 40);
        _currentTabView.tableHeaderView = _tableHeaderView;
    }];
}

- (void)stopSearchHintAnimation{
    [UIView animateWithDuration:.5 animations:^{
        _tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        _hintView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        _currentTabView.tableHeaderView = _tableHeaderView;
    }];
}


#pragma mark - 带搜索栏的无网络展示视图
- (UIView *)searchHintView{
    //承载所有控件的背景视图
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    _tableHeaderView = backView;
    //提示图片以及文字
    UIView *imageLableBack = [self hintView];
    _hintView = imageLableBack;
    [backView addSubview:imageLableBack];
    //搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _currentSearchBar = searchBar;
    searchBar.showsCancelButton = YES;
    [backView addSubview:searchBar];
    return backView;
}


#pragma Mark - 不带任何其他空间的无网络展示视图
- (UIView *)hintView{
    //提示背景视图
    UIView *hintBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    hintBackView.backgroundColor = ColorWithRGB(252, 223, 224, 1);
    
    //图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.2, 25, 25)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.layer.cornerRadius = 25/2;
    imageView.layer.masksToBounds = YES;
    [hintBackView addSubview:imageView];
    
    //提示内容
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, self.view.frame.size.width-50, 40)];
    contentLabel.text = @"当前网络不可用，请检查你的网络设置";
    contentLabel.font = [UIFont systemFontOfSize:14];
    [hintBackView addSubview:contentLabel];
    return hintBackView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"测试数据！TEST！";
    return cell;
}


#pragma mark - 滑动操作停止是执行
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < -40) {//如果当前位移大于缓存位移，说明scrollView向上滑动
    _currentTabView .contentInset =UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


#pragma mark - 点击事件
- (void)clickAction:(UIButton *)sender{
    if (sender.tag == 1) {//无网络状态
        sender.tag = 2;
        __weak  typeof(self)weakself = self;
//            [weakself startAnimation];
        [weakself startSearchHintAnimation];
    }else{//有网络状态
        sender.tag = 1;
//        [self stopAnimation];
        [self stopSearchHintAnimation];
    }
}


@end









