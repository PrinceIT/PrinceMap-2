//
//  AreaListViewController.m
//  PrinceMap
//
//  Created by administrator on 2014/1/10.
//  Copyright (c) 2014年 Prince Housing & Development Corp. All rights reserved.
//

#import "DistrictListViewController.h"

@interface DistrictListViewController ()

@end

@implementation DistrictListViewController

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
    return [self.array_district count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@的鄉鎮市區 (%i筆)",self.str_city,(int)[self.array_district count]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DistrictCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.array_district[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addressQuery:indexPath];
}

- (void) addressQuery:(NSIndexPath *)indexPath {
    UIAlertView *alertDialog;
    NSString *mapURL = [NSString stringWithFormat:@"http://10.35.36.80/JSON/QueryAddress.aspx?City=%@&District=%@&Address=",
                        [self.str_city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        [self.array_district[indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    alertDialog = [self getAlertDialog:@"資料讀取中..." message:nil buttonTitle:nil];
    [alertDialog show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 加載JSON的NSURLRequest對象中
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:mapURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
        // 將取得的JSON數據放到NSData對象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            
            [alertDialog dismissWithClickedButtonIndex:0 animated:NO];
            
            if (response != nil) {
                // 將取得之NSData解析至NSDictionary
                self.array_listcell = [[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error] objectForKey:@"data"];
                // 傳遞資料並顯示於TableView中
                [self performSegueWithIdentifier:@"DistrictView_to_ListView" sender:self];
            } else {
                [self showAlertDialog:@"警告" message:@"查無資料或伺服器無回應 !" buttonTitle:@"OK"];
            }
        });
    });
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ListViewController *destinationVC = (ListViewController *)segue.destinationViewController;
    destinationVC.array_cell = self.array_listcell;
}

- (void)showAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
    [alertDialog show];
}

- (UIAlertView *)getAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
    return alertDialog;
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
