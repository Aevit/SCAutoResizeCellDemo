//
//  ViewController.m
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/3.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "ViewController.h"
#import "AutoResizeCellController.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aBtn.frame = (CGRect){.origin = CGPointZero, .size = CGSizeMake(80, 80)};
    aBtn.center = self.view.center;
    aBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    aBtn.layer.borderWidth = 1.;
    aBtn.layer.cornerRadius = 40.;
    [aBtn setTitle:@"show" forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [aBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [aBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aBtn];
    
    [aBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnPressed:(id)sender {
    AutoResizeCellController *con = [[AutoResizeCellController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:con];
    [self presentViewController:nav animated:YES completion:^{
        ;
    }];
}

@end
