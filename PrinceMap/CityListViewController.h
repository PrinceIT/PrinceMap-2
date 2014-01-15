//
//  CityListViewController.h
//  PrinceMap
//
//  Created by administrator on 2014/1/10.
//  Copyright (c) 2014年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistrictListViewController.h"

@interface CityListViewController : UITableViewController

@property (strong,nonatomic) NSDictionary *dict_result;
@property (strong,nonatomic) NSArray *array_city;
@property (strong,nonatomic) NSArray *array_area;

@end
