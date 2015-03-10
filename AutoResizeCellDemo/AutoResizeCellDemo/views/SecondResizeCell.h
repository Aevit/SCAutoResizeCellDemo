//
//  SecondResizeCell.h
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/11.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondResizeCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UIImageView *avatarImgView;

- (void)initModel:(id)model;

@end
