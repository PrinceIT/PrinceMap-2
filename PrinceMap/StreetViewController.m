//
//  StreetViewController.m
//  PrinceMap
//
//  Created by administrator on 2014/1/1.
//  Copyright (c) 2014年 Prince Housing & Development Corp. All rights reserved.
//

#import "StreetViewController.h"

@interface StreetViewController ()

@end

@implementation StreetViewController

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
    NSLog(@"%@",self.dict_cell);
    self.view.autoresizesSubviews = NO;
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-568h"]]];
    // 設定位置
    float leftmargin = 10;
    float rightmargin = 10;
    float bottommargin = 5;
    float size_height = 20;
    float size_fullwidth = self.view.frame.size.width - leftmargin - rightmargin;
    float size_helfwidth = (size_fullwidth - 40) / 2;
    float visible_height = self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    
    _lbl_address = [[UILabel alloc] initWithFrame:CGRectMake(leftmargin, visible_height - size_height * 3 - bottommargin * 3, size_fullwidth, size_height)];
    _lbl_trans_date = [[UILabel alloc] initWithFrame:CGRectMake(leftmargin, _lbl_address.frame.origin.y + size_height + bottommargin, size_helfwidth, size_height)];
    _lbl_total_price = [[UILabel alloc] initWithFrame:CGRectMake(leftmargin + size_helfwidth, _lbl_trans_date.frame.origin.y, size_helfwidth, size_height)];
    _lbl_unit_price = [[UILabel alloc] initWithFrame:CGRectMake(leftmargin, _lbl_trans_date.frame.origin.y + size_height + bottommargin, size_helfwidth, size_height)];
    _lbl_build_area = [[UILabel alloc] initWithFrame:CGRectMake(leftmargin + size_helfwidth, _lbl_unit_price.frame.origin.y, size_helfwidth, size_height)];

    // 收藏按鈕
    _btn_savefav = [[UIButton alloc] initWithFrame:CGRectMake(_lbl_total_price.frame.origin.x + size_helfwidth, _lbl_total_price.frame.origin.y, 45, 45)];
    [_btn_savefav setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [_btn_savefav setTitle:@"收藏" forState:UIControlStateNormal];
    _btn_savefav.titleLabel.font = [UIFont systemFontOfSize:14];
    [_btn_savefav addTarget:self action:@selector(saveFav) forControlEvents:UIControlEventTouchUpInside];
    
    // 字體
    _lbl_address.font = [UIFont boldSystemFontOfSize:16];
    _lbl_trans_date.font = [UIFont systemFontOfSize:14];
    _lbl_total_price.font = [UIFont systemFontOfSize:14];
    _lbl_unit_price.font = [UIFont systemFontOfSize:14];
    _lbl_build_area.font = [UIFont systemFontOfSize:14];
    
    // 給值
    _lbl_address.text = [NSString stringWithFormat:@"%@%@%@",[self.dict_cell objectForKey:@"City"],[self.dict_cell objectForKey:@"District"],[self.dict_cell objectForKey:@"Address"]];
    _lbl_trans_date.text = [NSString stringWithFormat:@"交易年月:%@",[self.dict_cell objectForKey:@"Trans_Date"]];
    _lbl_total_price.text = [NSString stringWithFormat:@"交易總價:%.0f萬",[[self.dict_cell objectForKey:@"Total_Price"] floatValue]/10000];
    _lbl_unit_price.text = [NSString stringWithFormat:@"每坪單價:%.2f萬",[[self.dict_cell objectForKey:@"Unit_Price"] floatValue]/0.3025/10000];
    _lbl_build_area.text = [NSString stringWithFormat:@"總 面 積 :%.2f坪",[[self.dict_cell objectForKey:@"Build_Area"] floatValue]*0.3025];
    
    // 增加街景View
    _panoramaview = [GMSPanoramaView panoramaWithFrame:CGRectMake(leftmargin,10,size_fullwidth,_lbl_address.frame.origin.y - 20) nearCoordinate:CLLocationCoordinate2DMake([[self.dict_cell objectForKey:@"Latitude"] doubleValue],[[self.dict_cell objectForKey:@"Longitude"] doubleValue])];
    
    [self.view addSubview:_panoramaview];
    [self.view addSubview:_lbl_address];
    [self.view addSubview:_lbl_trans_date];
    [self.view addSubview:_lbl_total_price];
    [self.view addSubview:_lbl_unit_price];
    [self.view addSubview:_lbl_build_area];
    [self.view addSubview:_btn_savefav];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoStartPosition:(id)sender {
    // 回起點
    [_panoramaview moveNearCoordinate:CLLocationCoordinate2DMake([[self.dict_cell objectForKey:@"Latitude"] doubleValue], [[self.dict_cell objectForKey:@"Longitude"] doubleValue])];
}

- (void)saveFav {
    // 收藏至資料庫
    //NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *dbpath = [docsdir stringByAppendingPathComponent:@"Search.sqlite"];
    NSString *dbpath = [[NSBundle mainBundle] pathForResource:@"Search" ofType:@"sqlite"];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        return;
    } else {
        //NSNumber *lat = [NSNumber numberWithFloat:[[self.dict_cell objectForKey:@"Latitude"] floatValue]];
        //NSNumber *lon = [NSNumber numberWithFloat:[[self.dict_cell objectForKey:@"Longitude"] floatValue]];
        //NSLog(@"%@,%@",lat,lon);
        //NSLog(@"%@",self.dict_cell);
        //FMResultSet *res = [db executeQuery:@"SELECT COUNT(*) FROM FAddress WHERE Latitude = ? AND Longitude = ?",lat,lon];
        NSNumber *int_id = [NSNumber numberWithInt:[[self.dict_cell objectForKey:@"ID"] integerValue]];
        FMResultSet *res = [db executeQuery:@"SELECT COUNT(*) FROM FAddress WHERE ID = ?",int_id];
        
        if ([res next]) {
            int cnt = [res intForColumnIndex:0];
            if (cnt == 0) {
                NSString *sql = @"insert into FAddress (Address,Build_Area,City,Detials,District,ID,Latitude,Longitude,Total_Price,Trans_Date,Type,Unit_Price) values (:Address,:Build_Area,:City,:Detials,:District,:ID,:Latitude,:Longitude,:Total_Price,:Trans_Date,:Type,:Unit_Price)";
                [db executeUpdate:sql withParameterDictionary:self.dict_cell];
            }
        }
        [db close];
    }
}

- (void)showAlertDialog:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle
{
    UIAlertView *alertDialog;
    alertDialog = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    alertDialog.alertViewStyle = UIAlertViewStyleDefault;
    [alertDialog show];
}

@end
