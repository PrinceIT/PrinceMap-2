//
//  SearchViewController.m
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-568h"]]];
    //[self.btn_search setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.btn_search setBackgroundImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
    
    // 從SearchData.json解析成Dictionary
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SearchData" ofType:@"json"];
    NSData *dataResult = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    _dictResult = [NSJSONSerialization JSONObjectWithData:dataResult options:NSJSONReadingMutableLeaves error:&error];
    
    // 建立PickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 43, 320, 480)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView setShowsSelectionIndicator:YES];
    
    // 建立Toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 56)];
    _toolbar.barStyle = UIBarStyleBlackOpaque;
    [_toolbar sizeToFit];
    
    // 設定Toolbar上之Button
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    [_toolbar setItems:barItems animated:YES];
    
    // 設定輸入方式爲PickerView及toolbar上之確認按鈕
    self.txt_city.inputView = _pickerView;
    self.txt_city.inputAccessoryView = _toolbar;
    
    self.txt_area.inputView = _pickerView;
    self.txt_area.inputAccessoryView = _toolbar;
    
    self.txt_type.inputView = _pickerView;
    self.txt_type.inputAccessoryView = _toolbar;
    
    self.txt_street.inputAccessoryView = _toolbar;
    
    self.txt_year.inputView = _pickerView;
    self.txt_year.inputAccessoryView = _toolbar;
    
    self.txt_price_min.inputAccessoryView = _toolbar;
    self.txt_price_max.inputAccessoryView = _toolbar;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger txt_tag = textField.tag;
    int i = (int)[[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year] - 1911;
    NSMutableArray *array_year = [[NSMutableArray alloc] init];

    _currentTextField = textField;
    
    // 設定現在停留之TextField及應出現於PickerView中之內容
    switch (txt_tag) {
        case 1:
            _currentArray = [_dictResult objectForKey:@"city"];
            // 若空白則給初值
            if ([self.txt_city.text isEqualToString:@""]) {
                self.txt_city.text = _currentArray[0];
            }
            break;
        case 2:
           // 若空白則給初值
            if ([self.txt_city.text isEqualToString:@""]) {
                self.txt_city.text = [_dictResult objectForKey:@"city"][0];
            }
            _currentArray = [_dictResult objectForKey:self.txt_city.text];
            // 若空白則給初值
            if ([self.txt_area.text isEqualToString:@""]) {
                self.txt_area.text = _currentArray[0];
            }
            break;
        case 3:
            _currentArray = [_dictResult objectForKey:@"type"];
            // 若空白則給初值
            if ([self.txt_type.text isEqualToString:@""]) {
                self.txt_type.text = _currentArray[0];
            }
            break;
        case 5:
            [array_year addObject:@"全部"];
            for (; i >= 102; i--) {
                [array_year addObject:[NSString stringWithFormat:@"%i",i]];
            }
            _currentArray = (NSArray *)array_year;
            // 若空白則給初值
            if ([self.txt_year.text isEqualToString:@""]) {
                self.txt_year.text = _currentArray[0];
            }
            break;
        default:
            break;
    }
    
    // 設定內容區大小,使ScrollView生效
    if (txt_tag <= 3 || txt_tag == 5) {
        // 重新載入PickerView
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:0 inComponent:0 animated:NO];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height + _toolbar.frame.size.height + _pickerView.frame.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height + _pickerView.frame.size.height);
    }
}

- (void)pickerDoneClicked
{
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height);
    [_currentTextField resignFirstResponder];
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [_currentArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [_currentArray objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSInteger txt_tag = _currentTextField.tag;
    
    switch (txt_tag) {
        case 1:
            self.txt_city.text = [_currentArray objectAtIndex:row];
            if (self.txt_city.text != _currentTextField.text) {
                self.txt_area.text = [_dictResult objectForKey:self.txt_city.text][0];
            }
            break;
        case 2:
            self.txt_area.text = [_currentArray objectAtIndex:row];
            break;
        case 3:
            self.txt_type.text = [_currentArray objectAtIndex:row];
            break;
        case 5:
            self.txt_year.text = [_currentArray objectAtIndex:row];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)on_search_click:(id)sender {
    // 檢查輸入值是否正確
    if ([self.txt_city.text isEqual:@""] || [self.txt_area.text isEqualToString:@""]) {
        [self showAlertDialog:@"警告" message:@"縣市及鄉鎮市區不可空白 !" buttonTitle:@"OK"];
    } else {
        // 取得符合條件之明細資料並傳遞至ListView
        [self addressQuery];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ListViewController *destinationVC = (ListViewController *)segue.destinationViewController;
    destinationVC.array_cell = self.array_listcell;
}

- (void) addressQuery {
    UIAlertView *alertDialog;
    NSString *mapURL = [NSString stringWithFormat:@"http://10.35.36.80/JSON/QueryAddress.aspx?City=%@&District=%@&Address=%@",
                        [self.txt_city.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        [self.txt_area.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        [self.txt_street.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

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
                [self performSegueWithIdentifier:@"SearchView_to_ListView" sender:self];
            } else {
                [self showAlertDialog:@"警告" message:@"查無資料或伺服器無回應 !" buttonTitle:@"OK"];
            }
        });
    });
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

@end
