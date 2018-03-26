//
//  DKSTableController.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/20.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSTableController.h"
#import "DKSLeftCell.h"
#import "DKSRightCell.h"

#define Left_Cell @"leftCell"
#define Right_Cell @"rightCell"
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface DKSTableController ()

@property (nonatomic, strong) UITableView *leftTabView;
@property (nonatomic, strong) UITableView *rightTabView;

@property (nonatomic, strong) NSArray *leftAry;

@end

@implementation DKSTableController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown; //标志滚动方向，默认YES，滚动方向向上
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联动";
    
    _isScrollDown = YES; //上拉
    self.leftAry = @[@"服饰", @"鞋包", @"母婴", @"男装", @"女装", @"百货", @"手机", @"食品", @"电器", @"家纺"];
    [self.view addSubview:self.leftTabView];
    [self.view addSubview:self.rightTabView];
    [self.leftTabView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark ====== UITableViewDelegate ======
//有多少个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTabView) {
        return 1;
    } else {
        return 10;
    }
}

//每个分区有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTabView) {
        return self.leftAry.count;
    } else {
        return 4;
    }
}

//区头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.leftTabView) {
        return 0.1;
    } else {
        return 30;
    }
}

//区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightTabView) {
        UIView *headView = [UIView new];
        UILabel *headLabel = [UILabel new];
        headLabel.frame = CGRectMake(8, 0, K_Width *0.7 - 8, 30);
        headLabel.text = self.leftAry[section];
        headLabel.backgroundColor = [UIColor brownColor];
        [headView addSubview:headLabel];
        return headView;
    } else {
        return nil;
    }
}
/**
 * 这段代码主要是为了消除UITableView与底部留有的空白
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTabView) {
        return nil; //没有
    } else {
        return @" "; //设置为空格
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTabView) {
        [self.leftTabView registerClass:[DKSLeftCell class] forCellReuseIdentifier:Left_Cell];
        DKSLeftCell *leftCell = [self.leftTabView dequeueReusableCellWithIdentifier:Left_Cell forIndexPath:indexPath];
        leftCell.leftLabel.text = self.leftAry[indexPath.row];
        return leftCell;
    } else {
        [self.rightTabView registerClass:[DKSRightCell class] forCellReuseIdentifier:Right_Cell];
        DKSRightCell *rightCell = [self.rightTabView dequeueReusableCellWithIdentifier:Right_Cell forIndexPath:indexPath];
        rightCell.rightLabel.text = [NSString stringWithFormat:@"%@->第%@行", self.leftAry[indexPath.section], @(indexPath.row)];
        return rightCell;
    }
}

#pragma mark ====== 点击方法 ======
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_leftTabView == tableView) {
        _selectIndex = indexPath.row;
        [_rightTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark ====== 右侧滚动时左侧滚动到相应位置 ======
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static CGFloat lastOffsetY = 0;
    UITableView *tableView = (UITableView *)scrollView;
    if (_rightTabView == tableView && (_rightTabView.dragging || _rightTabView.decelerating)) {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y ? YES : NO;
        lastOffsetY = scrollView.contentOffset.y;
        
        //滑动到了顶部
        if (scrollView.contentOffset.y < 0) {
            [self selectRowAtIndexPath:0];
        }
        CGFloat height = scrollView.frame.size.height;
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
        //滚动到底部
        if (bottomOffset < height) {
            [self selectRowAtIndexPath:self.leftAry.count - 1];
        }
    }
}

// TableView 分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向下， RightTableView 是用户拖拽而产生滚动的（（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    //防止右边数据较多时崩溃
    if (section == 0) {
        return;
    }
    //向下滑动
    if ((_rightTabView == tableView) && !_isScrollDown && (_rightTabView.dragging || _rightTabView.decelerating)) {
        [self selectRowAtIndexPath:section];
        return;
    }
}

// TableView 分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    // 当前的 tableView 是 RightTableView，RightTableView 滚动的方向向上， RightTableView 是用户拖拽而产生滚动的（主要判断 RightTableView 用户拖拽而滚动的，还是点击 LeftTableView 而滚动的）
    if (section == (self.leftAry.count - 1)) {
        return;
    }
    //向上滑动
    if ((_rightTabView == tableView) && _isScrollDown && (_rightTabView.dragging || _rightTabView.decelerating)) {
        [self selectRowAtIndexPath:section + 1];
    }
}

// 当拖动右边 TableView 的时候，处理左边 TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    [_leftTabView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark ====== init ======
- (UITableView *)leftTabView {
    if (!_leftTabView) {
        _leftTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Width * 0.3, K_Height - 64) style:UITableViewStylePlain];
        _leftTabView.delegate = self;
        _leftTabView.dataSource = self;
        _leftTabView.rowHeight = 50;
        _leftTabView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTabView;
}

- (UITableView *)rightTabView {
    if (!_rightTabView) {
        _rightTabView = [[UITableView alloc] initWithFrame:CGRectMake(K_Width * 0.3, 0, K_Width * 0.7, K_Height - 64) style:UITableViewStyleGrouped];
        _rightTabView.backgroundColor = [UIColor whiteColor];
        _rightTabView.delegate = self;
        _rightTabView.dataSource = self;
        _rightTabView.rowHeight = 50;
        //去掉第一个头部视图的下移高度
        _rightTabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Width, CGFLOAT_MIN)];
        _rightTabView.tableFooterView = [[UIView alloc] init];
        _rightTabView.sectionFooterHeight = 0.01;
    }
    return _rightTabView;
}

@end
