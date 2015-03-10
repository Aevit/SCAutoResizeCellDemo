//
//  AutoResizeCell.h
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/3.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoResizeCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *bodyLabel;

- (void)initModel:(id)model;

@end
