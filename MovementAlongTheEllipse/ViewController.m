//
//  ViewController.m
//  MovementAlongTheEllipse
//
//  Created by Виктория on 20.01.16.
//  Copyright © 2016 Виктория. All rights reserved.
//
//
//  ChooseTalentViewController.m
//  ModelAlliance
//
//  Created by Виктория on 12.08.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "BulletListLabel.h"
#import <GLKit/GLKit.h>
#import "BallonImageView.h"
#import "ViewController.h"
#import "HorizontalScroller.h"

#define PINK_COLOR [UIColor colorWithRed:255.0/255.0 green:123.0/255.0 blue:166.0/255.0 alpha:1.0]
#define ORANGE_COLOR [UIColor colorWithRed:255.0/255.0 green:170.0/255.0 blue:110.0/255.0 alpha:1.0]
#define VIOLET_COLOR [UIColor colorWithRed:178.0/255.0 green:135.0/255.0 blue:247.0/255.0 alpha:1.0]
#define GUEST_COLOR [UIColor colorWithRed:254.0/255.0 green:205.0/255.0 blue:126.0/255.0 alpha:1.0]

BOOL iPhone4 = NO;

typedef NS_ENUM(NSUInteger, DirectionOnMotion) {
    fromRight = 1,
    fromLeft = -1
};

@interface ViewController ()
{
    NSArray *roleArray;
    CGFloat height;
    CGFloat angle, motionRadiusX, motionRadiusY, rad;
    BallonImageView *ballonImageView, *leftImageView, *rightImageView;
    CGPoint startPosition;
    NSMutableArray *arrayOfImageView;
    CGFloat sizeForBoundImageView, sizeOfHorda, heightOfBorderBall, heightOfCenterBall;
    BulletListLabel *bulletLabel;
    TypeForColor indexColor;
    NSMutableArray *arrayOfVectors;
    BOOL successLeft, successRight;
    NSTimer *timer;
    CGPoint zeroPoint;
    NSDictionary *currentColor;
    BallonImageView *imageViewFirst;
}


@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet HorizontalScroller *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ovalLineImageView;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

- (void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    iPhone4 = [[UIScreen mainScreen] bounds].size.height <= 480;
    heightOfBorderBall = self.scrollView.frame.size.height/2;
    heightOfCenterBall = self.scrollView.frame.size.height;
    currentColor = [NSDictionary new];
    roleArray = @[[UIImage imageNamed:@"pink_circle"], [UIImage imageNamed:@"orange_circle"], [UIImage imageNamed:@"violet_circle"], [UIImage imageNamed:@"pink_circle"], [UIImage imageNamed:@"orange_circle"], [UIImage imageNamed:@"violet_circle"]];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    sizeForBoundImageView = self.scrollView.frame.size.height/2;
    sizeOfHorda = self.scrollView.frame.size.width;
    arrayOfImageView = [NSMutableArray new];
    
    for (int i=0; i<3; i++) {
        ballonImageView = [[BallonImageView alloc] initWithFrame:CGRectMake(0, 0, sizeForBoundImageView, sizeForBoundImageView)];
        CGFloat startAngle;
        if (i == 0) {
            startAngle = atan(40/(self.ovalLineImageView.frame.size.width/2))+0.4;
            ballonImageView.heightOfBall = heightOfBorderBall;
        } else if (i == 1) {
            startAngle = M_PI / 2;
            ballonImageView.tag = 1;
            ballonImageView.heightOfBall = heightOfCenterBall;
        } else if ( i == 2 ) {
            startAngle = M_PI - atan(40/(self.ovalLineImageView.frame.size.width/2)) - 0.4;
            ballonImageView.heightOfBall = heightOfBorderBall;
        }
        ballonImageView.centerEllipse = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2 + self.ovalLineImageView.frame.size.height + 40);
        ballonImageView.radiusEllipse = CGSizeMake(self.ovalLineImageView.frame.size.width/2 + 40, self.ovalLineImageView.frame.size.height + 40);
        ballonImageView.alpha = startAngle;
        ballonImageView.image = roleArray[i];
        [self.scrollView addSubview:ballonImageView];
        [ballonImageView addGestureRecognizer:panGestureRecognizer];
        [arrayOfImageView addObject:ballonImageView];
    }
    [self showDataForColorAtIndex:1];
    successLeft = successRight = YES;
    arrayOfVectors = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextViewNotification:) name:@"ChangeTextViewNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint touchLocation = [panGestureRecognizer locationInView:self.view];
    self.scrollView.center = touchLocation;
    
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    CGPoint point=[[touches anyObject] locationInView:self.scrollView];
    startPosition = zeroPoint = point;
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event {
    //NSLog(@"Touches Moved");
    CGPoint point = [[touches anyObject] locationInView:self.scrollView];
    [arrayOfVectors addObject:@(point.x)];
    
    BOOL flagSuccess = YES;
    for (BallonImageView *imageView in arrayOfImageView) {
        [imageView testPoint:asin((point.x - startPosition.x) / (self.ovalLineImageView.frame.size.width/2 + 40))];
        if (imageView.tag == 1) {
            if (imageView.x1 > self.view.frame.size.width && imageView.y1 > self.scrollView.frame.size.height/2 + self.ovalLineImageView.frame.size.height) {
                flagSuccess = NO;
            } else if ( imageView.x1 < 0 && imageView.y1 > self.scrollView.frame.size.height/2 + self.ovalLineImageView.frame.size.height ) {
                flagSuccess = NO;
            }
        }
    }
    if (flagSuccess) {
        for (BallonImageView *imageView in arrayOfImageView) {
            imageView.betta = asin((point.x - startPosition.x) / (self.ovalLineImageView.frame.size.width/2));
            successLeft = successRight = YES;
        }
        startPosition = point;
    } else {
        for (BallonImageView *imageView in arrayOfImageView) {
            if (imageView.center.x < self.view.frame.size.width && imageView.x1 > self.view.frame.size.width && imageView.y1 > self.view.frame.size.height && successRight) {
                imageView.betta = asin((self.view.frame.size.width - imageView.center.x) / ((self.ovalLineImageView.frame.size.width/2 + 40)));
                successRight = NO;
            } else if (imageView.center.x > 0 && imageView.x1 < 0 && imageView.y1 > self.view.frame.size.height && successLeft){
                imageView.betta = asin(- imageView.center.x / ((self.ovalLineImageView.frame.size.width / 2) + 40));
                successLeft = NO;
            }
        }
    }
    
    
}

- (void)updateToRight:(NSTimer *)timer1  {
    
    if (imageViewFirst.betta < 3 * M_PI_2) {
        for (BallonImageView *imageView in arrayOfImageView) {
            imageView.betta = 2 * M_PI / 180;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTextViewNotification" object:self userInfo:@{@"index":timer1.userInfo[@"i"]}];
        [timer invalidate];
        timer = nil;
    }
}

- (void)updateToLeft:(NSTimer *)timer1 {
    
    if (imageViewFirst.betta > 3 * M_PI_2) {
        for (BallonImageView *imageView in arrayOfImageView) {
            imageView.betta = - 2 * M_PI / 180;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTextViewNotification" object:self userInfo:@{@"index":timer1.userInfo[@"i"]}];
        [timer invalidate];
        timer = nil;
    }
}

- (void)changeTextViewNotification:(NSNotification *)notification
{
    for (id subview in self.textView.subviews) {
        [subview removeFromSuperview];
    }
    [self showDataForColorAtIndex:[notification.userInfo[@"index"] integerValue]];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event {
    
    CGPoint point=[[touches anyObject] locationInView:self.scrollView];
    [arrayOfVectors addObject:@(point.x)];
    
    if (zeroPoint.x < point.x) {
        int i = 0;
        imageViewFirst = arrayOfImageView[0];
        if (!(imageViewFirst.center.x > 0 && imageViewFirst.center.x < self.view.frame.size.width/2)) {
            i = 1;
            imageViewFirst = arrayOfImageView[i];
        }
        [timer invalidate];
        timer = nil;
        CGFloat time = 1.0/60.0;
        timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(updateToRight:) userInfo:@{@"i":@(i)} repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
        int i = 2;
        imageViewFirst = arrayOfImageView[2];
        [imageViewFirst testPoint:imageViewFirst.betta];
        if (!(imageViewFirst.center.x >= self.view.frame.size.width/2 && imageViewFirst.center.x <= self.view.frame.size.width)) {
            imageViewFirst = arrayOfImageView[1];
            i = 1;
        }
        [timer invalidate];
        timer = nil;
        CGFloat time = 1.0/60.0;
        timer = [NSTimer timerWithTimeInterval:time target:self selector:@selector(updateToLeft:) userInfo:@{@"i":@(i)} repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

- (void)showDataForColorAtIndex:(int)index {
    height = 0;
    int realIndex = index;
    
    for (int i = 0; i < arrayOfImageView.count; i++) {
        BallonImageView *imageView = arrayOfImageView[i];
        if (imageView.center.x < 2 * sizeOfHorda / 3 && imageView.center.x > sizeOfHorda / 3) {
            realIndex = i;
        }
    }
    
    indexColor = realIndex;
    currentColor = [self getColorParametrsForIndexColor:indexColor];
    for (int i=0; i < [currentColor[@"text"] count]; i++) {
        
        bulletLabel = [[BulletListLabel alloc] initWithFrame:CGRectMake(0, height, self.textView.frame.size.width, 30.0)];
        [bulletLabel setTextForLabel:[currentColor[@"text"] objectAtIndex:i] forRole:indexColor];
        if (iPhone4) {
            CGSize maximumLabelSize     = CGSizeMake(244, FLT_MAX);
            NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
            NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:20]};
            CGRect labelBounds = [bulletLabel.text boundingRectWithSize:maximumLabelSize
                                                                options:options
                                                             attributes:attr
                                                                context:nil];
            
            labelBounds.size.width = 244;
            labelBounds.size.height += 15;
            labelBounds.origin.y = height;
            bulletLabel.frame = labelBounds;
            
        } else {
            [self resizeHeightToFitForLabel:bulletLabel];
        }
        
        height += bulletLabel.frame.size.height;
        [self.textView addSubview:bulletLabel];
    }
    NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:currentColor[@"title"] attributes:@{NSForegroundColorAttributeName:currentColor[@"color"]}];
    self.colorLabel.attributedText = attribute;

}

- (CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text {
    CGSize maximumLabelSize     = CGSizeMake(244, FLT_MAX);
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    CGRect expectedLabelSize = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return expectedLabelSize.size.height;
}

- (void)resizeHeightToFitForLabel:(UILabel *)label
{
    CGRect newFrame         = label.frame;
    newFrame.size.height    = [self heightForLabel:label withText:label.text];
    label.frame             = newFrame;
}

- (NSDictionary *) getColorParametrsForIndexColor: (int)Int{
    NSDictionary *dict = [[NSDictionary alloc] init];
    switch (Int) {
        case -1:
            dict = @{@"color": GUEST_COLOR,
                     @"title":@"guest",
                     @"text":@[@"First string",
                               @"Second string",
                               @"Theird string",
                               @"Fourth string"],
                     };
            break;
            
        case 0:
            dict = @{@"color":PINK_COLOR,
                     @"title": @"Pink",
                     @"text":@[@"First string",
                               @"Second string",
                               @"Theird string"],
                     };
            
            break;
        case 1:
            dict = @{@"color":ORANGE_COLOR,
                     @"title":@"Orange",
                     @"text":@[@"First string",
                               @"Second string",
                               @"Theird string"],
                     };
            
            break;
            
        case 2:
            dict = @{@"color": VIOLET_COLOR,
                     @"title":@"Violet",
                     @"text":@[@"First string",
                               @"Second string",
                               @"Theird string",
                               @"Fourth string"],
                     };
            
            break;
        default:
            dict = @{@"error" : @"error"};
            break;
    }
    return dict;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
