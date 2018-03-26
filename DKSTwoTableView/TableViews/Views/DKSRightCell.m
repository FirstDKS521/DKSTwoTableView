//
//  DKSRightCell.m
//  DKSTwoTableView
//
//  Created by aDu on 2018/3/20.
//  Copyright © 2018年 DuKaiShun. All rights reserved.
//

#import "DKSRightCell.h"

@implementation DKSRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightLabel.frame = CGRectMake(8, 0, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
