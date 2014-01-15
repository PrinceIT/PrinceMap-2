//
//  MapViewController.h
//  PrinceMap
//
//  Created by administrator on 2013/12/24.
//  Copyright (c) 2013年 Prince Housing & Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "StreetViewController.h"

@interface MapViewController : UIViewController <GMSMapViewDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *map;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *maptype;
@property (strong, nonatomic) NSArray *array_cell;
@property (strong, nonatomic) NSMutableArray *array_marker;

- (IBAction)change_maptype:(id)sender;

- (void) addMarker;
- (void) showMarker;
- (BOOL) markerInBounds:(float)northEast_lat :(float)northEast_lon :(float)southWest_lat :(float)southWest_lon :(GMSMarker *)marker;

@end
