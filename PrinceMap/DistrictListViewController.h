//
//  AreaListViewController.h
//  PrinceMap
//
//  Created by administrator on 2014/1/10.
//  Copyright (c) 2014年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface DistrictListViewController : UITableViewController

@property (strong,nonatomic) NSString *str_city;
@property (strong,nonatomic) NSArray *array_district;
@property (strong,nonatomic) NSArray *array_listcell;

- (void) addressQuery:(NSIndexPath *)indexPath;
- (void)showAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
- (UIAlertView *)getAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
