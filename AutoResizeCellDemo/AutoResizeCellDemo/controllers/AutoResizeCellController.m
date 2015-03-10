//
//  AutoResizeCellController.m
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/3.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "AutoResizeCellController.h"
#import "SVProgressHUD.h"
#import "AutoResizeCell.h"
#import "SecondResizeCell.h"
#import "Masonry.h"

#define SWITCH_SIMPLE_DEMO  1

#define HAS_AVATAR      @"hasAvatar"
#define ROW_DATA_KEY    @"rowDataKey"

static NSString *autoResizeCellId = @"autoResizeCellId";
static NSString *secondResizeCellId = @"secondResizeCellId";


@interface AutoResizeCellController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *offscreenCell;

@property (nonatomic, assign) BOOL isInsertACellOnTop;

@end

@implementation AutoResizeCellController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"auto resize cell";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"options" style:UIBarButtonItemStylePlain target:self action:@selector(optionsBtnPressed:)];
    
    self.isInsertACellOnTop = NO;
    
    [self generateDataArrayWithSectionNum:2 rowNum:2];
    
    UITableView *aTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    aTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    aTable.delegate = self;
    aTable.dataSource = self;
    [self.view addSubview:aTable];
    self.myTableView = aTable;
    
    [aTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    /////////////// step: 1 ///////////////
    self.offscreenCell = [NSMutableDictionary dictionary];
    /////////////// step: 1 ///////////////
    
    /////////////// step: 2 ///////////////
    [self.myTableView registerClass:[AutoResizeCell class] forCellReuseIdentifier:autoResizeCellId];
    [self.myTableView registerClass:[SecondResizeCell class] forCellReuseIdentifier:secondResizeCellId];
    // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
    // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
    self.myTableView.estimatedRowHeight = UITableViewAutomaticDimension; // iOS7+
    /////////////// step: 2 ///////////////
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
+ (NSString *)randomStringOfMaxLength:(int)maxLength {
    static NSString *characters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    int length = arc4random_uniform(maxLength);
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%c", [characters characterAtIndex: arc4random_uniform((int)[characters length])]];
    }
    return randomString;
}

- (void)generateDataArrayWithRowNum:(NSInteger)rowNum {
    [self generateDataArrayWithSectionNum:1 rowNum:rowNum];
}

- (void)generateDataArrayWithSectionNum:(NSInteger)sectionNum rowNum:(NSInteger)rowNum {
    sectionNum = (sectionNum <= 0 ? 1 : sectionNum);
    rowNum = (rowNum <= 0 ? 1 : rowNum);
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    NSLog(@"will generate %ld section, and %ld rowNum for each section", (long)sectionNum, (long)rowNum);
    self.title = [NSString stringWithFormat:@"%ld section, %ld row for each section", (long)sectionNum, (long)rowNum];
    int sectionCount = 0;
    for (NSInteger i = 0; i < sectionNum; i++) {
        NSMutableArray *rowArr = (self.isInsertACellOnTop && [_dataArray count] > 0 ? [self getRowDataArrInSection:0] : [NSMutableArray array]);
        int rowCount = 0;
        for (NSInteger j = 0; j < rowNum; j++) {
            NSDictionary *rowDict = @{
                                      HAS_AVATAR: @(arc4random() % 2),
                                      @"title": [NSString stringWithFormat:@"%d: %@", rowCount,[AutoResizeCellController randomStringOfMaxLength:50]],
                                      @"content": [AutoResizeCellController randomStringOfMaxLength:200]
                                      };
            rowCount++;
            [rowArr insertObject:rowDict atIndex:0];
        }
        
        NSDictionary *sectionDict = @{@"sectionTitle": [NSString stringWithFormat:@"The %d section", sectionCount],
                                      ROW_DATA_KEY: rowArr
                                      };
        sectionCount++;
        if (self.isInsertACellOnTop && [_dataArray count] > 0) {
            [_dataArray replaceObjectAtIndex:0 withObject:sectionDict];
        } else {
            [_dataArray insertObject:sectionDict atIndex:0];
        }
    }
}

#pragma mark - actions
- (void)backBtnPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)optionsBtnPressed:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"choose" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:
#if !SWITCH_SIMPLE_DEMO
                         @"delete all",
                         @"delete first cell",
                         @"delete first section",
                         @"insert a cell on top",
                         @"insert a section on top",
                         @"reGet data for one section",
                         @"reGet data for multi sections",
#endif
                         @"change the text for the first cell",
                         @"change the text for the first section", nil];
    [as showInView:self.view];
}

#pragma mark - actionsheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    self.isInsertACellOnTop = NO;
    switch (buttonIndex) {
#if SWITCH_SIMPLE_DEMO
        case 0:
        {
            // change the text for the first cell
            [self changeTheTextOfTheFirstCell];
            break;
        }
        case 1:
        {
            // change the text for the first section
            [self changeTheTextOfTheFirstSection];
            break;
        }
#else
        case 0:
        {
            // delete all
            NSInteger dataCount = [self.dataArray count];
            [self.dataArray removeAllObjects];
            [self.myTableView beginUpdates];
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, dataCount)] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"Thanks"];
            });
            break;
        }
        case 1:
        {
            // delete first cell
            if ([self.dataArray count] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"the section num is 0"];
                return;
            }
            if ([[self getRowDataArrInSection:0] count] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"the row num of the first section is 0"];
                return;
            }
            [[self getRowDataArrInSection:0] removeObjectAtIndex:0];
            [self.myTableView beginUpdates];
            [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            break;
        }
        case 2:
        {
            // delete first section
            if ([_dataArray count] <= 0) {
                [SVProgressHUD showErrorWithStatus:@"the section num is 0"];
                return;
            }
            [self.dataArray removeObjectAtIndex:0];
            [self.myTableView beginUpdates];
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            break;
        }
        case 3:
        {
            // insert a cell on the top
            self.isInsertACellOnTop = YES;
            BOOL hasAtLeastOneSection = ([self.dataArray count] > 0 ? YES : NO);
            [self generateDataArrayWithRowNum:1];
            [self.myTableView beginUpdates];
            if (hasAtLeastOneSection) {
                [self.myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.myTableView endUpdates];
            break;
        }
        case 4:
        {
            // insert a section on the top
            [self generateDataArrayWithSectionNum:1 rowNum:3];
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self.myTableView endUpdates];
            break;
        }
        case 5:
        {
            // reGet data for one section
            [self.dataArray removeAllObjects];
            [self generateDataArrayWithRowNum:arc4random() % 100];
            [self.myTableView reloadData];
            break;
        }
        case 6:
        {
            // reGet data for multi sections
            [self.dataArray removeAllObjects];
            [self generateDataArrayWithSectionNum:(arc4random() % 5) rowNum:(arc4random() % 50)];
            [self.myTableView reloadData];
            break;
        }
        case 7:
        {
            // change the text for the first cell
            [self changeTheTextOfTheFirstCell];
            break;
        }
        case 8:
        {
            // change the text for the first section
            [self changeTheTextOfTheFirstSection];
            break;
        }
#endif
        default:
            break;
    }
}

// change the text for the first cell
- (void)changeTheTextOfTheFirstCell {
    if ([self.dataArray count] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"the section num is 0"];
        return;
    }
    if ([[self getRowDataArrInSection:0] count] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"the row num of the first section is 0"];
        return;
    }
    NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:[self getRowDataDictInSection:0 row:0]];
    [aDict setObject:[AutoResizeCellController randomStringOfMaxLength:50] forKey:@"title"];
    [aDict setObject:[AutoResizeCellController randomStringOfMaxLength:200] forKey:@"content"];
    [[self getRowDataArrInSection:0] replaceObjectAtIndex:0 withObject:aDict];
    [self.myTableView beginUpdates];
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView endUpdates];
}

// change the text for the first section
- (void)changeTheTextOfTheFirstSection {
    if ([self.dataArray count] <= 0) {
        [SVProgressHUD showErrorWithStatus:@"the section num is 0"];
        return;
    }
    NSInteger firstSectionCount = [[self getRowDataArrInSection:0] count];
    [self.dataArray removeObjectAtIndex:0];
    [self generateDataArrayWithSectionNum:1 rowNum:firstSectionCount];
    [self.myTableView beginUpdates];
    [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.myTableView endUpdates];
}

#pragma mark - get data
- (NSDictionary*)getSectionDataDictInSection:(NSInteger)section {
    return _dataArray[section];
}

- (NSMutableArray*)getRowDataArrInSection:(NSInteger)section {
    return [_dataArray[section] objectForKey:ROW_DATA_KEY];
}

- (NSDictionary*)getRowDataDictInSection:(NSInteger)section row:(NSInteger)row {
    return [self getRowDataArrInSection:section][row];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self getRowDataArrInSection:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self getSectionDataDictInSection:section] objectForKey:@"sectionTitle"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /////////////// step: 3 ///////////////
    NSDictionary *aDict = [self getRowDataDictInSection:indexPath.section row:indexPath.row];
    BOOL hasAvatar = [[aDict objectForKey:HAS_AVATAR] boolValue];
    NSString *reuseIdentifier = (hasAvatar ? secondResizeCellId : autoResizeCellId);
    UITableViewCell *cell = [self.offscreenCell objectForKey:reuseIdentifier];
    if (!cell) {
        if (hasAvatar) {
            cell = [[SecondResizeCell alloc] init];
        } else {
            cell = [[AutoResizeCell alloc] init];
        }
        [self.offscreenCell setObject:cell forKey:reuseIdentifier];
    }
    if (hasAvatar) {
        [(SecondResizeCell*)cell initModel:aDict];
    } else {
        [(AutoResizeCell*)cell initModel:aDict];
    }
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    /////////////// step: 3 ///////////////
    
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /////////////// step: 4 ///////////////
    NSDictionary *aDict = [self getRowDataDictInSection:indexPath.section row:indexPath.row];
    BOOL hasAvatar = [[aDict objectForKey:HAS_AVATAR] boolValue];
    NSString *reuseIdentifier = (hasAvatar ? secondResizeCellId : autoResizeCellId);
    AutoResizeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (hasAvatar) {
        [(SecondResizeCell*)cell initModel:aDict];
    } else {
        [(AutoResizeCell*)cell initModel:aDict];
    }
    /////////////// step: 4 ///////////////
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
