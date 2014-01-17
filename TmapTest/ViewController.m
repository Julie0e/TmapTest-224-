//
//  ViewController.m
//  TmapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"
#import "DetailViewController.h"

#define APP_KEY @"cc2d4ba7-e770-3d07-b088-7f54326a4405"
#define TOOLBAR_HIGHT 140


@interface ViewController () <TMapViewDelegate, TMapGpsManagerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *transportType;
@property (strong, nonatomic) TMapView *mapView;
@property (strong, nonatomic) TMapMarkerItem *startMarker, *endMarker;
@property (strong, nonatomic) TMapGpsManager *gpsManager;


@end

@implementation ViewController

#pragma mark T-MAP DELEGATE
#pragma mark GPS Manaer's Delegate

- (void)locationChanged:(TMapPoint *)newTmp
{
    NSLog(@"Location Changed : %@", newTmp);
    [self.mapView setCenterPoint:newTmp];
}

- (void)headingChanged:(double)heading
{
    
}
- (IBAction)switchGPS:(id)sender {
    UISwitch * _switch = (UISwitch *)sender;
    
    if (_switch.on == YES) {
        [self.gpsManager openGps];
    }
    else{
        [self.gpsManager closeGps];
    }
}

- (IBAction)transportTypeChanged:(id)sender
{
    [self showPath];
}

- (void)showPath
{
    TMapPathData *path = [[TMapPathData alloc] init];
    
    TMapPolyLine *line = [path findPathDataWithType:self.transportType.selectedSegmentIndex startPoint:[self.startMarker getTMapPoint] endPoint:[self.endMarker getTMapPoint]];
    
    if (line != nil) {
        [self.mapView showFullPath:@[line]];
        
        [self.mapView bringMarkerToFront:self.startMarker];
        [self.mapView bringMarkerToFront:self.endMarker];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [self showPath];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.mapView clearCustomObjects];
    
    NSString *keyword = searchBar.text;
    TMapPathData *path = [[TMapPathData alloc] init];
    NSArray *result = [path requestFindAddressPOI:keyword];
    NSLog(@"Number of POI : %d", (int)result.count);
    
    int i = 0;
    for (TMapPOIItem *item in result)
    {
        NSLog(@"Name : %@ - Point : %@", [item getPOIName], [item getPOIPoint]);
        NSString *markerID = [NSString stringWithFormat:@"marker_%d", i++];
        TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
        [marker setTMapPoint:[item getPOIPoint]];
        [marker setIcon:[UIImage imageNamed:@"red_pin.png"]];
        
        [marker setCanShowCallout:YES];
        [marker setCalloutTitle:[item getPOIName]];
        [marker setCalloutSubtitle:[item getPOIAddress]];
        
        [self.mapView addCustomObject:marker ID:markerID];
    }
}

- (void)onClick:(TMapPoint *)point
{
    NSLog(@"Tapped Point : %@", point);
}

- (void)onLongClick:(TMapPoint *)point
{
    NSLog(@"Long Clicked : %@", point);
}

- (void)onCalloutRightbuttonClick:(TMapMarkerItem *)markerItem
{
    NSLog(@"Market ID : %@", [markerItem getID]);
    if ([@"T-ACADEMY" isEqualToString:[markerItem getID]]) {
        DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        detailVC.urlStr = @"http://tacademy.co.kr";
        [self presentViewController:detailVC animated:YES completion:nil];
    }
    
}

- (void)onCustomObjectClick:(TMapObject *)obj
{
    if ([obj isKindOfClass:[TMapMarkerItem class]]) {
        TMapMarkerItem *marker = (TMapMarkerItem *)obj;
        NSLog(@"Marker Clicked...%@",[marker getID]);
    }
}
- (IBAction)addOverlay:(id)sender
{
    CLLocationCoordinate2D coord[5] = {
        CLLocationCoordinate2DMake(37.460143,126.914062),
        CLLocationCoordinate2DMake(37.469136,126.981869),
        CLLocationCoordinate2DMake(37.437930,126.989937),
        CLLocationCoordinate2DMake(37.413255,126.959038),
        CLLocationCoordinate2DMake(37.426752,126.913548)
    };
    
    TMapPolygon *polygon = [[TMapPolygon alloc]init];
    [polygon setLineColor:[UIColor redColor]];
    
    [polygon setPolygonAlpha:0];
    [polygon setLineWidth:8.0];
    
    for (int i =0; i<5; i++) {
        [polygon addPolygonPoint:[TMapPoint mapPointWithCoordinate:coord[i]]];
    }
    [self.mapView addTMapPolygonID:@"관악산" Polygon:polygon];
}

- (IBAction)addMarker:(id)sender
{
    NSString *itemID = @"T-ACADEMY";
    
    TMapPoint *point = [[TMapPoint alloc]initWithLon:126.96 Lat:37.466];
    TMapMarkerItem *marker = [[TMapMarkerItem alloc] initWithTMapPoint:point];
    [marker setIcon:[UIImage imageNamed:@"t_logo.png"]];
    
     [marker setCanShowCallout:YES];
     [marker setCalloutTitle:@"티 아카데미"];
     [marker setCalloutRightButtonImage:[UIImage imageNamed:@"right_arrow.png"]];
     
     [self.mapView addTMapMarkerItemID:itemID Marker:marker];
}

- (IBAction)moveToNTower:(id)sender {
    TMapPoint *centerPoint = [[TMapPoint alloc]initWithLon:126.96 Lat:37.466];
    [self.mapView setCenterPoint:centerPoint];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	CGRect rect = CGRectMake(0, TOOLBAR_HIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBAR_HIGHT);
    
    self.mapView =[[TMapView alloc]initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];
    [self.view addSubview:self.mapView];
    //self.mapView.zoomLevel = 12.0;
    
    self.mapView.delegate = self;
    
    self.gpsManager = [[TMapGpsManager alloc] init];
    [self.gpsManager setDelegate:self];
    
    
    self.startMarker = [[TMapMarkerItem alloc] init];
    [self.startMarker setIcon:[UIImage imageNamed:@"red_pin.png"]];
    TMapPoint *startPoint = [self.mapView convertPointToGpsX:50 andY:50];
    [self.startMarker setTMapPoint:startPoint];
    [self.mapView addCustomObject:self.startMarker ID:@"START"];
    
    self.endMarker = [[TMapMarkerItem alloc] init];
    [self.endMarker setIcon:[UIImage imageNamed:@"red_pin.png"]];
    TMapPoint *endPoint = [self.mapView convertPointToGpsX:300 andY:300];
    [self.endMarker setTMapPoint:endPoint];
    [self.mapView addCustomObject:self.endMarker ID:@"END"];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
