//
//  SearchViewController.h
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

@interface SearchViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    NSDictionary *_dictResult;
    UITextField *_currentTextField;
    NSArray *_currentArray;
    UIPickerView *_pickerView;
    UIToolbar *_toolbar;
}
@property (weak, nonatomic) IBOutlet UITextField *txt_city;
@property (weak, nonatomic) IBOutlet UITextField *txt_area;
@property (weak, nonatomic) IBOutlet UITextField *txt_type;
@property (weak, nonatomic) IBOutlet UITextField *txt_street;
@property (weak, nonatomic) IBOutlet UITextField *txt_year;
@property (weak, nonatomic) IBOutlet UITextField *txt_price_min;
@property (weak, nonatomic) IBOutlet UITextField *txt_price_max;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *array_listcell;

- (IBAction)on_search_click:(id)sender;

- (void)addressQuery;
- (void)showAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;
- (UIAlertView *)getAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
