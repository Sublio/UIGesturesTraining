//
//  ViewController.m
//  GesturesTest
//
//  Created by Denis on 11.06.17.
//  Copyright © 2017 Denis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property(weak,nonatomic) UIView* testView;
@property (assign, nonatomic)CGFloat testViewScale;
@property (assign, nonatomic)CGFloat testViewRotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(
                                                          CGRectGetMidX(self.view.bounds) -50,
                                                          CGRectGetMidY(self.view.bounds) -50,
                                                          100,100)];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    view.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:view];
    
    self.testView = view;
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
       [self.view addGestureRecognizer:tapRecognizer];
    
    
    UITapGestureRecognizer* doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    
    UITapGestureRecognizer* doubleTapWithTwoTouchesRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTapWithTwoTouchesGesture:)];
    
    doubleTapWithTwoTouchesRecognizer.numberOfTapsRequired = 2;
    doubleTapWithTwoTouchesRecognizer.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:doubleTapWithTwoTouchesRecognizer];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    
    rotationGesture.delegate = self;
    [self.view addGestureRecognizer:rotationGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
};



-(UIColor*)randomColor{
    CGFloat r = (float)(arc4random()%256) /255.f;
    CGFloat g = (float)(arc4random()%256) /255.f;
    CGFloat b = (float)(arc4random()%256) /255.f;
    
    UIColor* color = [[UIColor alloc]initWithRed:r green:g blue:b alpha:1.f];
    
    return color;
    
}

-(void)handlePanGesture:(UIPanGestureRecognizer*) panGesture {
    
    NSLog(@"handlePan");
    
    self.testView.center = [panGesture locationInView:self.view];
    
    
}

-(void)handleRotationGesture:(UIRotationGestureRecognizer*) rotationGesture{
    
    
    
    
    if(rotationGesture.state == UIGestureRecognizerStateBegan){
        
        
        self.testViewRotation = 0;
    }
    
    CGFloat newRotation = rotationGesture.rotation - self.testViewRotation;
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
    
    self.testView.transform = newTransform;
    
    self.testViewRotation = rotationGesture.rotation;
    
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}


-(void)handleTapGesture:(UITapGestureRecognizer*) tapGesture{
    
    NSLog(@"tap %@",NSStringFromCGPoint([tapGesture locationInView:self.view]) );
    
    self.testView.backgroundColor = [self randomColor];
    
}

-(void)handleDoubleTapGesture:(UITapGestureRecognizer*) tapGesture{
    
    NSLog(@"double tap %@",NSStringFromCGPoint([tapGesture locationInView:self.view]) );
    
    
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.2f, 1.2f);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = newTransform;
    }];
  
    self.testViewScale = 1.2f;
}

-(void)handleDoubleTapWithTwoTouchesGesture:(UITapGestureRecognizer*) tapGesture{
    
    NSLog(@"double tap with two touches %@",NSStringFromCGPoint([tapGesture locationInView:self.view]) );
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1.8f, 1.8f);
    self.view.transform = newTransform;
    
    self.testViewScale = 0.8f;
    
}

-(void)handlePinch:(UIPinchGestureRecognizer*)pinchGesture{
    NSLog(@"handle pinch %1.3f",pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        
        self.testViewScale = 1.f;
    }
    CGFloat newScale = 1.0 + pinchGesture.scale - self.testViewScale;
    CGAffineTransform currentTransform = self.testView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.testView.transform = newTransform;
    self.testViewScale = pinchGesture.scale;
}


@end
