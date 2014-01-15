//
//  ListViewController.h
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"
#import "MapViewController.h"
#import "StreetViewController.h"

@interface ListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listview;

@property (strong, nonatomic) NSArray *array_cell;

- (void)reloadFavListView;

- (IBAction)delFav:(id)sender;

@end
