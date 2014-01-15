//
//  ListViewController.m
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.navigationController.tabBarItem.tag == 4) {
        [self reloadFavListView];
    }
}

- (void)reloadFavListView
{
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@"Search" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        return;
    } else {
        NSMutableArray *array_fav = [[NSMutableArray alloc] init];
        NSString *sql = @"SELECT Address,Build_Area,City,Detials,District,ID,Latitude,Longitude,Total_Price,Trans_Date,Type,Unit_Price FROM FAddress";
        FMResultSet *res = [db executeQuery:sql];
        while ([res next]) {
            [array_fav addObject:[res resultDictionary]];
        }
        self.array_cell = array_fav;
    }
    [db close];
    
    [self.listview reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.array_cell count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"實價登錄明細 (%i筆)",(int)[self.array_cell count]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListCell";
    ListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *dict_cell = self.array_cell[indexPath.row];
    cell.lbl_Address.text = [NSString stringWithFormat:@"%@%@%@",[dict_cell objectForKey:@"City"],[dict_cell objectForKey:@"District"],[dict_cell objectForKey:@"Address"]];
    cell.lbl_Unit_Price.text = [NSString stringWithFormat:@"每坪單價：%.2f萬",[[dict_cell objectForKey:@"Unit_Price"] doubleValue]/0.3025/10000];
    cell.lbl_Total_Price.text = [NSString stringWithFormat:@"交易總價：%.0f萬",[[dict_cell objectForKey:@"Total_Price"] doubleValue]/10000];
    cell.lbl_Build_Area.text = [NSString stringWithFormat:@"總  面  積：%.2f坪",[[dict_cell objectForKey:@"Build_Area"] doubleValue]*0.3025];
    cell.lbl_Trans_Date.text = [NSString stringWithFormat:@"交易年月：%@",[dict_cell objectForKey:@"Trans_Date"]];
    // ID
    [cell.btn_delfav setTag:(NSInteger)[[dict_cell objectForKey:@"ID"] intValue]];
    
    if (self.navigationController.tabBarItem.tag == 4) {
        // 取消收藏按鈕
        [cell.btn_delfav setHidden:NO];
    } else {
        [cell.btn_delfav setHidden:YES];
    }
    
    return cell;
}

- (IBAction)delFav:(id)sender
{
    // 至資料庫刪除收藏
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@"Search" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        return;
    } else {
        UIButton *btn = (UIButton *)sender;
        NSNumber *int_id = [NSNumber numberWithInt:btn.tag];
        
        NSString *sql = @"delete from FAddress where ID = ?";
        [db executeUpdate:sql,int_id];
    }

    [db close];
    [self reloadFavListView];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ListView_to_StreetView"]) {
        StreetViewController *destinationVC = (StreetViewController *)segue.destinationViewController;
        destinationVC.dict_cell = self.array_cell[self.tableView.indexPathForSelectedRow.row];
    } else {
        MapViewController *destinationVC = (MapViewController *)segue.destinationViewController;
        destinationVC.array_cell = self.array_cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
