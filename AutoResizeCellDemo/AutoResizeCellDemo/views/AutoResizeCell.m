//
//  AutoResizeCell.m
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/3.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "AutoResizeCell.h"
#import "Masonry.h"

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        5.0f

@interface AutoResizeCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation AutoResizeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // titleLabel
        if (!_titleLabel) {
            UILabel *aLbl = [[UILabel alloc] init];
            aLbl.numberOfLines = 0;
            aLbl.font = [UIFont systemFontOfSize:16];
            aLbl.textColor = [UIColor blackColor];
            aLbl.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:aLbl];
            self.titleLabel = aLbl;
        }
        
        // bodyLabel
        if (!_bodyLabel) {
            UILabel *aLbl = [[UILabel alloc] init];
            aLbl.numberOfLines = 0;
            aLbl.font = [UIFont systemFontOfSize:14];
            aLbl.textColor = [UIColor blackColor];
            aLbl.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:aLbl];
            self.bodyLabel = aLbl;
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    /////////////// step: 6 ///////////////
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);
    _bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(_bodyLabel.frame);
    /////////////// step: 6 ///////////////
}

- (void)updateConstraints {
    
    /////////////// step: 5 ///////////////
    if (!self.didSetupConstraints) {
        
        // titleLabel
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kLabelVerticalInsets);
            make.left.mas_equalTo(kLabelHorizontalInsets);
            make.right.mas_equalTo(-kLabelHorizontalInsets); // need
        }];
        // bodyLabel
        [_bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).with.offset(kLabelVerticalInsets);
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.bottom.mas_equalTo(-kLabelVerticalInsets); // need
            make.right.mas_equalTo(_titleLabel.mas_right);
        }];
        self.didSetupConstraints = YES;
    }
    [super updateConstraints];
    /////////////// step: 5 ///////////////
}

- (void)initModel:(id)model {
    
    self.titleLabel.text = [model objectForKey:@"title"];
    self.bodyLabel.text = [model objectForKey:@"content"];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    /////////////// step: 4 ///////////////
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    /////////////// step: 4 ///////////////
}








@end
