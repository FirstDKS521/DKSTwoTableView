//
//  DKSTabCollController.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/23.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSTabCollController.h"
#import "DKSCollectionHeadView.h"
#import "DKSCollectionCell.h"
#import "DKSLeftCell.h"

#define Left_Cell @"leftCell"
#define Right_Cell @"rightCell"
#define Head_View @"headView"
#define K_Width [UIScreen mainScreen].bounds.size.width
#define K_Height [UIScreen mainScreen].bounds.size.height
@interface DKSTabCollController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *leftAry;
@property (nonatomic, assign) BOOL isScrollDown; //滑动方向

@end

@implementation DKSTabCollController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tab和Col联动";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isScrollDown = YES; //默认向上
    self.leftAry = @[@"服饰", @"鞋包", @"母婴", @"男装", @"女装", @"百货", @"手机", @"食品", @"电器", @"家纺"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark ====== UITableViewDelegate ======
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DKSLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:Left_Cell forIndexPath:indexPath];
    cell.leftLabel.text = self.leftAry[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    [self collectionViewScrollToIndexPath:indexPath];
}

#pragma mark ====== 解决CollectionView区头视图被隐藏的问题 ======
- (void)collectionViewScrollToIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *rIndexPath = [NSIndexPath indexPathForItem:0 inSection:indexPath.row];//获取要滚动的区
    //获取此区的布局属性
    UICollectionViewLayoutAttributes *att = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:rIndexPath];
    //滚动位置
    CGPoint top = CGPointMake(0, att.frame.origin.y - self.collectionView.contentInset.top);
    //如果需要滚动到的区域+CollectionView的高度大于CollectionView的contentSize.height
    if ((top.y + self.collectionView.frame.size.height) > self.collectionView.contentSize.height) {
        CGPoint offset = CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height);
        //collectionView滚动到底部
        [self.collectionView setContentOffset:offset animated:YES];
    } else {
        //collectionView滚动到相应的位置
        [self.collectionView setContentOffset:top animated:YES];
    }
}

#pragma mark ====== UICollectionViewDelegate ======
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.leftAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DKSCollectionHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:Head_View forIndexPath:indexPath];
        headView.titleLabel.text = self.leftAry[indexPath.section];
        headView.backgroundColor = [UIColor orangeColor];
        [headView setBtnBlock:^{
            NSLog(@"点击了%@区的更多按钮", @(indexPath.section));
        }];
        return headView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DKSCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Right_Cell forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@区-%@行", @(indexPath.section), @(indexPath.row)];
    return cell;
}

#pragma mark ====== collectionView区头视图将要展示 ======
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    //主要判断collectionView用户拖拽而滚动的，还是点击TableView而滚动的
    if (!_isScrollDown && (collectionView.dragging || collectionView.decelerating)) { //向下滚动
        if (indexPath.section == 0) {
            [self selectRowAtIndexPath:indexPath.section];
        } else {
            [self selectRowAtIndexPath:indexPath.section - 1];
        }
    }
}

#pragma mark ====== 视图将要展示结束 向上滚动 ======
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (_isScrollDown && (collectionView.dragging || collectionView.decelerating)) {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

//当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark ====== UIScrollViewDelegate ======
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static float lastOffSetY = 0;
    if (self.collectionView == scrollView) {
        self.isScrollDown = lastOffSetY < scrollView.contentOffset.y;
        lastOffSetY = scrollView.contentOffset.y;
    }
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;
    //滚动到底部
    if (bottomOffset < height) {
        [self selectRowAtIndexPath:self.leftAry.count - 1];
    }
}

#pragma mark ====== init ======
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Width * 0.3, K_Height - 64) style:UITableViewStylePlain];
        [_tableView registerClass:[DKSLeftCell class] forCellReuseIdentifier:Left_Cell];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = (K_Width * 0.7 - 41) / 3;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(width, width + 20);
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(0, 30);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(K_Width * 0.3, 0, K_Width * 0.7, K_Height - 64) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[DKSCollectionCell class] forCellWithReuseIdentifier:Right_Cell];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册区头视图
        [_collectionView registerClass:[DKSCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:Head_View];
    }
    return _collectionView;
}

@end
