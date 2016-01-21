//
//  HorizontalScroller.m
//  ModelAlliance
//
//  Created by Виктория on 12.08.15.
//  Copyright (c) 2015 Mac. All rights reserved.
//

#import "HorizontalScroller.h"

// 1
#define VIEW_PADDING 20
#define VIEW_DIMENSIONS 118
#define VIEWS_OFFSET 80

// 2
@interface HorizontalScroller () <UIScrollViewDelegate>
@end

// 3
@implementation HorizontalScroller
{
    UIScrollView *scroller;
}

- (void)setScrollView {
    scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scroller.delegate = self;
    scroller.showsHorizontalScrollIndicator = NO;
    [self addSubview:scroller];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerTapped:)];
    [scroller addGestureRecognizer:tapRecognizer];
    
}

- (void)scrollerTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:gesture.view];
    // we can't use an enumerator here, because we don't want to enumerate over ALL of the UIScrollView subviews.
    // we want to enumerate only the subviews that we added
    for (int index=0; index<3; index++)
    {
        UIView *view = scroller.subviews[index];
        if (CGRectContainsPoint(view.frame, location))
        {
            [self.delegate horizontalScroller:self clickedViewAtIndex:index];
            [scroller setContentOffset:CGPointMake(view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, 0) animated:YES];
            break;
        }
    }
}

- (void)reload
{
    // 1 - nothing to load if there's no delegate
    if (self.delegate == nil) return;
    
    // 2 - remove all subviews
    [scroller.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    // 3 - xValue is the starting point of the views inside the scroller
    CGFloat xValue = VIEWS_OFFSET;
    for (int i=0; i<3; i++)
    {
        // 4 - add a view at the right position
        if (1 == i) {
            xValue += VIEW_PADDING;
            UIImageView *imageView = [self.delegate horizontalScroller:self viewAtIndex:i];
            imageView.frame = CGRectMake(xValue, 0, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
            [scroller addSubview:imageView];
            xValue += VIEW_DIMENSIONS+VIEW_PADDING;
        } else {
            xValue += VIEW_PADDING;
            UIImageView *imageView = [self.delegate horizontalScroller:self viewAtIndex:i];
            imageView.frame = CGRectMake(xValue, 0.0, VIEW_DIMENSIONS, VIEW_DIMENSIONS);
            [scroller addSubview:imageView];
            xValue += VIEW_DIMENSIONS + VIEW_PADDING;
        }

    }
    
    // 5
    [scroller setContentSize:CGSizeMake(xValue+VIEWS_OFFSET, self.frame.size.height)];
    
    // 6 - if an initial view is defined, center the scroller on it

    NSInteger initialView = 1;//[self.delegate initialViewIndexForHorizontalScroller:self];
    [scroller setContentOffset:CGPointMake(initialView*(VIEW_DIMENSIONS+(2*VIEW_PADDING)), 0) animated:YES];
}

- (void)centerCurrentView
{
    int xFinal = scroller.contentOffset.x + (VIEWS_OFFSET/2) + VIEW_PADDING;
    int viewIndex = xFinal / (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    xFinal = viewIndex * (VIEW_DIMENSIONS+(2*VIEW_PADDING));
    [scroller setContentOffset:CGPointMake(xFinal,0) animated:YES];
    [self.delegate horizontalScroller:self clickedViewAtIndex:viewIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self centerCurrentView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerCurrentView];
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
//    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
//    CGFloat viewWidth = view.frame.size.width;
//    CGFloat viewHeight = view.frame.size.height;
//    
//    CGFloat x = 0;
//    CGFloat y = 0;
//    
//    if(viewWidth < screenWidth) {
//        x = screenWidth / 2;
//    }
//    if(viewHeight < screenHeight) {
//        y = screenHeight / 2 ;
//    }
//    
//    scrollView.contentInset = UIEdgeInsetsMake(y, x, y, x);
//}
@end
