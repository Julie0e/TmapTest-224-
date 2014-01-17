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
#define TOOLBAR_HIGHT 44


@interface ViewController () <TMapViewDelegate>

@property (strong, nonatomic) TMapView *mapView;
@end

@implementation ViewController

#pragma mark T-MAP DELEGATE

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
    self.mapView.zoomLevel = 12.0;
    
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
