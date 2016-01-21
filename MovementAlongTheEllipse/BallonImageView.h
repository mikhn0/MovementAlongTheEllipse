//
//  BallonImageView.h
//  ModelAlliance
//
//  Created by Imac on 18.08.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BallonImageView : UIImageView

@property (nonatomic) CGFloat alpha, betta, x1, y1, x, y, heightOfBall;
@property (nonatomic) CGPoint centerEllipse;
@property (nonatomic) CGSize radiusEllipse;

- (void)testPoint:(CGFloat)betta;

@end
