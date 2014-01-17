//
//  ViewController.m
//  TmapTest
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

#define APP_KEY @"cc2d4ba7-e770-3d07-b088-7f54326a4405"
#define TOOLBAR_HIGHT 44
@interface ViewController ()

@property (strong, nonatomic) TMapView *mapView;
@end

@implementation ViewController
- (IBAction)moveToNTower:(id)sender {
    TMapPoint *centerPoint = [[TMapPoint alloc]initWithLon:126.988220 Lat:37.551178];
    [self.mapView setCenterPoint:centerPoint];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGRect rect = CGRectMake(0, TOOLBAR_HIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBAR_HIGHT);
    
    self.mapView =[[TMapView alloc]initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];
    [self.view addSubview:self.mapView];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
