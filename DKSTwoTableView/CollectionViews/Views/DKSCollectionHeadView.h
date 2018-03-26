//
//  DKSCollectionHeadView.h
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/23.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlock)(void);
@interface DKSCollectionHeadView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, copy) BtnBlock btnBlock;

@end
