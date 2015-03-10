//
//  AutoResizeTableController.m
//  AutoResizeCellDemo
//
//  Created by Aevitx on 14/12/3.
//  Copyright (c) 2014年 Aevit. All rights reserved.
//

#import "AutoResizeTableController.h"
#import "AutoResizeCell.h"

#define CELL_CACHE_KEY_SC(indexPath)  [NSString stringWithFormat:@"%ld-%ld", (long)indexPath.section, (long)indexPath.row]

static NSString *autoResizeCellId = @"autoResizeCellId";

@interface AutoResizeTableController ()

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableDictionary *cellCacheDict;

@end

@implementation AutoResizeTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"auto resize cell";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"reload" style:UIBarButtonItemStylePlain target:self action:@selector(reloadTable:)];
    
    self.cellCacheDict = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
- (void)backBtnPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)reloadTable:(id)sender {
    [self.myTableView reloadData];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoResizeCell *cell = [self getCellWithIndexPath:indexPath];
    [_cellCacheDict setObject:cell forKey:CELL_CACHE_KEY_SC(indexPath)];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AutoResizeCell *cell = [_cellCacheDict objectForKey:CELL_CACHE_KEY_SC(indexPath)];
    if (!cell) {
        return [self getCellWithIndexPath:indexPath];
    }
    return cell;
}

- (AutoResizeCell*)getCellWithIndexPath:(NSIndexPath*)indexPath {
    AutoResizeCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:autoResizeCellId];
    if (!cell) {
        cell = [[AutoResizeCell alloc] init];
    }
    cell.titleLabel.text = @"标题";
    cell.bodyLabel.text = @"内容";
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
