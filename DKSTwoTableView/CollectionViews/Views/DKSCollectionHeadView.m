//
//  DKSCollectionHeadView.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/23.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSCollectionHeadView.h"

@implementation DKSCollectionHeadView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.frame = CGRectMake(8, 0, 80, frame.size.height);
        self.moreBtn.frame = CGRectMake(frame.size.width - 78, 0, 70, frame.size.height);
    }
    return self;
}

- (void)lookMore {
    if (self.btnBlock) {
        self.btnBlock();
    }
}

- (void)setBtnBlock:(BtnBlock)btnBlock {
    _btnBlock = btnBlock;
}

#pragma mark ====== init ======
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"查看更多 >" forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreBtn addTarget:self action:@selector(lookMore) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_moreBtn];
    }
    return _moreBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
