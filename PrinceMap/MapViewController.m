//
//  MapViewController.m
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
    // 初始化CameraPosition
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0 longitude:0.0 zoom:15 bearing:0 viewingAngle:0];
    self.map = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.map.delegate = self;
    // 限制 zoom level
    [self.map setMinZoom:15 maxZoom:self.map.maxZoom];
    self.map.myLocationEnabled = YES;
    self.map.settings.myLocationButton = YES;
    //self.map.settings.compassButton = YES;
    //self.map.settings.zoomGestures = YES;
    self.view = self.map;
    
    // 取得目前座標
    CLLocationCoordinate2D userLocation = self.map.myLocation.coordinate;
    if (userLocation.latitude == 0.0 && userLocation.longitude == 0.0) {
        // 110台灣台北市信義區松高路11號
        userLocation = CLLocationCoordinate2DMake(25.0393569, 121.565856);
    }
    [self.map animateToLocation:userLocation];
    
    // 加上GMSMarker
    [self addMarker];
    [self showMarker];
}

- (IBAction)change_maptype:(id)sender {
    if (self.map.mapType == kGMSTypeNormal) {
        self.maptype.title = [NSString stringWithFormat:@"地圖"];
        self.map.mapType = kGMSTypeHybrid;
    } else {
        self.maptype.title = [NSString stringWithFormat:@"衛星"];
        self.map.mapType = kGMSTypeNormal;
    }
}

- (void)addMarker
{
    NSDictionary *dict_cell = [[NSDictionary alloc] init];
    double lat,lon;
    NSString *strTitle = [NSString stringWithFormat:@"請按我看街景"];
    NSString *strAddress = [[NSString alloc] init];
    
    self.array_marker = [[NSMutableArray alloc] init];

    for (int i = 0; i < self.array_cell.count; i++) {
        dict_cell = self.array_cell[i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        lat = [[dict_cell objectForKey:@"Latitude"] doubleValue];
        lon = [[dict_cell objectForKey:@"Longitude"] doubleValue];
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        strAddress = [NSString stringWithFormat:@"%@%@%@",[dict_cell objectForKey:@"City"],[dict_cell objectForKey:@"District"],[dict_cell objectForKey:@"Address"]],
        marker.title = [NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:(strAddress.length - strTitle.length)*4/5 withString:@" " startingAtIndex:0],strTitle];
        marker.snippet = [NSString stringWithFormat:@"%@\n交易年月：%@ 總面積：%.2f坪\n每坪單價：%.2f萬 交易總價：%.0f萬",
                         strAddress,
                         [dict_cell objectForKey:@"Trans_Date"],
                         [[dict_cell objectForKey:@"Build_Area"] floatValue]*0.3025,
                         [[dict_cell objectForKey:@"Unit_Price"] floatValue]/0.3025/10000,
                         [[dict_cell objectForKey:@"Total_Price"] floatValue]/10000];
        [self.array_marker addObject:marker];
    }
}

- (void)showMarker
{
    int i = (int)self.array_marker.count;
    
    if (i > 0) {
        ((GMSMarker *)self.array_marker[0]).map = self.map;
        [self.map animateToLocation:CLLocationCoordinate2DMake(((GMSMarker *)self.array_marker[0]).position.latitude,((GMSMarker *)self.array_marker[0]).position.longitude)];
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    int i = 0;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:mapView.projection.visibleRegion];
    float southWest_lat = bounds.southWest.latitude;
    float southWest_lon = bounds.southWest.longitude;
    float northEast_lat = bounds.northEast.latitude;
    float northEast_lon = bounds.northEast.longitude;
    
    if (self.array_marker.count > 0) {
        for (i = 0; i < self.array_marker.count; i++) {
            if ([self markerInBounds:(float)northEast_lat :(float)northEast_lon :(float)southWest_lat :(float)southWest_lon :(GMSMarker *)self.array_marker[i]] == YES) {
                ((GMSMarker *)self.array_marker[i]).map = self.map;
            } else {
                ((GMSMarker *)self.array_marker[i]).map = nil;
            }
        }
    }
}

- (BOOL) markerInBounds:(float)northEast_lat :(float)northEast_lon :(float)southWest_lat :(float)southWest_lon :(GMSMarker *)marker;
{
    float marker_lat = marker.position.latitude;
    float marker_lon = marker.position.longitude;
    
    if (marker_lat <= northEast_lat && marker_lon <= northEast_lon && marker_lat >= southWest_lat && marker_lon >= southWest_lon) {
        return YES;
    } else {
        return NO;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self performSegueWithIdentifier:@"MapView_to_StreetView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    double lat,lon;
    StreetViewController *destinationVC = (StreetViewController *)segue.destinationViewController;
    for (int i = 0; i < self.array_cell.count; i++) {
        lat = [[self.array_cell[i] objectForKey:@"Latitude"] doubleValue];
        lon = [[self.array_cell[i] objectForKey:@"Longitude"] doubleValue];
        if (self.map.selectedMarker.position.latitude == lat && self.map.selectedMarker.position.longitude == lon) {
            destinationVC.dict_cell = self.array_cell[i];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
