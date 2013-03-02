//
//  ViewController.m
//  MapTest
//
//  Created by yuriken27 on 2013/03/02.
//  Copyright (c) 2013 yuriken27. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize map = _map;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // ロングプレスジェスチャーを作成
    
    UILongPressGestureRecognizer *longPressGesture;
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(handleLongPressGesture:)];
    [_map addGestureRecognizer:longPressGesture];
    _map.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 長押し検出時の処理
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {  // 長押し検出開始時のみ動作
        
        CGPoint touchedPoint = [gesture locationInView:_map];
        
        NSLog(@"touchedPoint x:[%f]", touchedPoint.x);
        NSLog(@"touchedPoint y:[%f]", touchedPoint.y);
        
        CLLocationCoordinate2D touchCoordinate = [_map convertPoint:touchedPoint toCoordinateFromView:_map];
        
        NSLog(@"touchCoordinate latitude:%f  longitude:%f", touchCoordinate.latitude, touchCoordinate.longitude);
        
        [self setAnnotation:touchCoordinate mapMove:NO animated:NO];
    }
}
-(void)setAnnotation:(CLLocationCoordinate2D) point mapMove:(BOOL)mapMove
            animated:(BOOL)animated{
    // ピンを全て削除
    [_map removeAnnotations: _map.annotations];
    // 新しいピンを作成
    MKPointAnnotation *anno = [[MKPointAnnotation alloc] init];
    anno.coordinate = point;
    
    // マップの表示を変更
    if (mapMove) {
        MKCoordinateSpan CoordinateSpan = MKCoordinateSpanMake(0.005,0.005);
        MKCoordinateRegion CoordinateRegion = MKCoordinateRegionMake(point,CoordinateSpan);
        [_map setRegion:CoordinateRegion animated:animated];
    }
    // ピンを追加
    [_map addAnnotation:anno];
    
    // ピンの周りに円を表示
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:point radius:500];  // 半径500m
    [_map removeOverlays:_map.overlays];
    [_map addOverlay:circle];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id )annotation
{
    static NSString* Identifier = @"PinAnnotationIdentifier";
    MKPinAnnotationView* pinView;
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
    
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:Identifier];
        pinView.animatesDrop = YES;
        return pinView;
    }
    pinView.annotation = annotation;
    return pinView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircle* circle = overlay;
    MKCircleView* circleOverlayView =   [[MKCircleView alloc] initWithCircle:circle];
    
    circleOverlayView.strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    circleOverlayView.lineWidth = 4.;
    circleOverlayView.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.25];
    return circleOverlayView;
}

@end
