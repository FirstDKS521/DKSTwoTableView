//
//  DKSCollectionCell.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/23.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSCollectionCell.h"

@implementation DKSCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView.frame = CGRectMake(5, 5, frame.size.width - 10, frame.size.width - 10);
        self.titleLabel.frame = CGRectMake(5, CGRectGetMaxY(self.imgView.frame) + 5, frame.size.width - 10, 20);
    }
    return self;
}

#pragma mark ====== init ======
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"headImg"];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
