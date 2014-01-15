//
//  StreetViewController.h
//  PrinceMap
//
//  Created by administrator on 2014/1/1.
//  Copyright (c) 2014年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FMDatabase.h"

@interface StreetViewController : UIViewController
{
    GMSPanoramaView *_panoramaview;
    UILabel *_lbl_address;
    UILabel *_lbl_trans_date;
    UILabel *_lbl_build_area;
    UILabel *_lbl_unit_price;
    UILabel *_lbl_total_price;
    UIButton *_btn_savefav;
}

@property (strong, nonatomic) NSDictionary *dict_cell;

- (IBAction)gotoStartPosition:(id)sender;
- (void)saveFav;
- (void)showAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
