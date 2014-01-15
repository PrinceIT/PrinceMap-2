//
//  ListCell.h
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbl_Address;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Build_Area;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Unit_Price;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Total_Price;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Trans_Date;

@property (strong, nonatomic) IBOutlet UIButton *btn_delfav;

@end
