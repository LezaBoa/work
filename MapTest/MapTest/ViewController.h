//
//  ViewController.h
//  MapTest
//
//  Created by yuriken27 on 2013/03/02.
//  Copyright (c) 2013 yuriken27. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;


@end
