//
//  BallonImageView.m
//  ModelAlliance
//
//  Created by Imac on 18.08.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BallonImageView.h"

@implementation BallonImageView

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha + M_PI;
    self.betta = _alpha;
}

- (void)setBetta:(CGFloat)betta {
    if (!isnan(betta)) {
        if (_betta) {
            _betta += betta;
        } else {
            _betta = betta;
        }
        _x = cos(_betta) * _radiusEllipse.width + _centerEllipse.x;
        _y = sin(_betta) * _radiusEllipse.height + _centerEllipse.y;
        self.frame = CGRectMake(0, 0, self.heightOfBall, self.heightOfBall);
        self.center = CGPointMake(_x, _y);
    }
}

- (void)testPoint:(CGFloat)betta {
    if (!isnan(betta)) {
        _x1 = cos(_betta+betta) * _radiusEllipse.width + _centerEllipse.x;
        _y1 = sin(_betta+betta) * _radiusEllipse.height + _centerEllipse.y;
    }
}


@end