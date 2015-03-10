//
//  SecondResizeCell.m
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/11.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "SecondResizeCell.h"
#import "Masonry.h"

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        8.0f

@interface SecondResizeCell ()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation SecondResizeCell

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
        
        // avatarImgView
        if (!_avatarImgView) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:imgView];
            self.avatarImgView = imgView;
        }
        
        // titleLabel
        if (!_titleLabel) {
            UILabel *aLbl = [[UILabel alloc] init];
            aLbl.numberOfLines = 0;
            aLbl.font = [UIFont systemFontOfSize:18];
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
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);
    _bodyLabel.preferredMaxLayoutWidth = CGRectGetWidth(_bodyLabel.frame);
}

- (void)updateConstraints {
    
    if (!self.didSetupConstraints) {
        
        // avatarImgView
        if (self.avatarImgView) {
            [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kLabelVerticalInsets);
                make.left.mas_equalTo(kLabelHorizontalInsets);
                make.right.mas_equalTo(_titleLabel.mas_left).with.offset(-kLabelHorizontalInsets);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
        }
        
        // titleLabel
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_avatarImgView) {
                make.top.mas_equalTo(_avatarImgView);
                make.left.mas_equalTo(_avatarImgView.mas_right).with.offset(kLabelHorizontalInsets);
            } else {
                make.top.mas_equalTo(kLabelVerticalInsets);
                make.left.mas_equalTo(kLabelHorizontalInsets);
            }
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
}

- (void)initModel:(id)model {
    
    if (self.avatarImgView) {
        self.avatarImgView.image = [UIImage imageNamed:@"avatar.jpeg"];
    }
    self.titleLabel.text = [model objectForKey:@"title"];
    self.bodyLabel.text = [model objectForKey:@"content"];
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
