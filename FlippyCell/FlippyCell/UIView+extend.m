//
//  UIView+extend.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/26/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "UIView+extend.h"

//establish enum

typedef NS_ENUM(NSInteger, FoldDirection) {
    
    directionOpen,
    directionClosed
};

@implementation UIView (extend)
                                                                         
- (void)closeWithTransparency:(BOOL)withTransparency withCompletionBlock:(void (^)(void))completionBlock {
    
    [self foldWithTransparency:withTransparency completionBlock:completionBlock inDirection:directionClosed];
}

- (void)openWithTransparency:(BOOL)withTransparency withCompletionBlock:(void (^)(void))completionBlock {
    
    [self foldWithTransparency:withTransparency completionBlock:completionBlock inDirection:directionOpen];
}

#pragma Private

- (void)foldWithTransparency:(BOOL)withTransparency
             completionBlock:(void (^)(void))completionBlock
                 inDirection:(FoldDirection)foldDirection {
    
    [self prepareSplitImage];
    
    NSArray *topAndBottomView = [self prepareSplitImage];
    UIView *topHalfView = topAndBottomView[0];
    UIView *bottomHalfView = topAndBottomView[1];
    
    UIView *animationContainer = [[UIView alloc] initWithFrame:self.bounds];
    UIColor *originalBackgroundColor = self.backgroundColor;
    if (withTransparency) {
        animationContainer.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        for (UIView *subview in self.subviews) {
            subview.hidden = YES;
        }
    } else {
        animationContainer.backgroundColor = [UIColor blackColor];
    }
    
    [self addSubview:animationContainer];
    [animationContainer addSubview:topHalfView];
    [animationContainer addSubview:bottomHalfView];
    
    CATransform3D startingTransform = CATransform3DIdentity;
    startingTransform.m34 = -1 / 500.f;
    
    CGRect startingFrame = CGRectMake(0,
                                      -topHalfView.frame.size.height / 2,
                                      topHalfView.frame.size.width,
                                      topHalfView.frame.size.height);
    topHalfView.frame = startingFrame;
    bottomHalfView.frame = startingFrame;
    
    topHalfView.layer.anchorPoint = CGPointMake(0.5, 0.0);
    bottomHalfView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    
    topHalfView.layer.transform = startingTransform;
    bottomHalfView.layer.transform = startingTransform;
    
    CAGradientLayer *topShadowLayer = [CAGradientLayer layer];
    topShadowLayer.colors = @[((id)[UIColor clearColor].CGColor), ((id)[UIColor blackColor].CGColor) ];
    topShadowLayer.frame = topHalfView.bounds;
    [topHalfView.layer addSublayer:topShadowLayer];
    
    CAGradientLayer *bottomShadowLayer = [CAGradientLayer layer];
    bottomShadowLayer.colors = @[((id)[UIColor blackColor].CGColor), ((id)[UIColor clearColor].CGColor) ];
    bottomShadowLayer.frame = bottomHalfView.bounds;
    [bottomHalfView.layer addSublayer:bottomShadowLayer];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    
    [CATransaction setCompletionBlock:^{
        self.backgroundColor = originalBackgroundColor;
        
        if (withTransparency) {
            for (UIView *subview in self.subviews) {
                subview.hidden = NO;
            }
        }
        
        [animationContainer removeFromSuperview];
        
        if (completionBlock) {
            completionBlock();
        }
    }];
    
    CABasicAnimation *topRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    topRotationAnimation.fillMode = kCAFillModeForwards;
    topRotationAnimation.removedOnCompletion = NO;
    switch (foldDirection) {
        case directionOpen:
            topRotationAnimation.fromValue = @(-M_PI_2);
            topRotationAnimation.toValue = @0;
            break;
        case directionClosed:
            topRotationAnimation.fromValue = @(0);
            topRotationAnimation.toValue = @-M_PI_2;
    }
    
    [topHalfView.layer addAnimation:topRotationAnimation forKey:nil];
    
    CABasicAnimation *bottomRotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    bottomRotationAnimation.fillMode = kCAFillModeForwards;
    bottomRotationAnimation.removedOnCompletion = NO;
    switch (foldDirection) {
        case directionOpen:
            bottomRotationAnimation.fromValue = @(M_PI_2);
            bottomRotationAnimation.toValue = @0;
            break;
        case directionClosed:
            bottomRotationAnimation.fromValue = @(0);
            bottomRotationAnimation.toValue = @(M_PI_2);
    }
    [bottomHalfView.layer addAnimation:bottomRotationAnimation forKey:nil];

    CABasicAnimation *bottomTranslationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    bottomTranslationAnimation.fillMode = kCAFillModeForwards;
    bottomTranslationAnimation.removedOnCompletion = NO;
    switch (foldDirection) {
        case directionOpen:
            bottomTranslationAnimation.fromValue = @(CGRectGetMinY(topHalfView.frame));
            bottomTranslationAnimation.toValue = @(2 * bottomHalfView.frame.size.height);
            bottomTranslationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            break;
        case directionClosed:
            bottomTranslationAnimation.fromValue = @(2 * bottomHalfView.frame.size.height);
            bottomTranslationAnimation.toValue = @(CGRectGetMinY(topHalfView.frame));
            bottomTranslationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    }
    
    //TODO: figure out a more precise timing function
    [bottomHalfView.layer addAnimation:bottomTranslationAnimation forKey:nil];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.removedOnCompletion = NO;
    switch (foldDirection) {
        case directionOpen:
            opacityAnimation.fromValue = @(1.0);
            opacityAnimation.toValue = @(0.0);
            break;
        case directionClosed:
            opacityAnimation.fromValue = @(0.0);
            opacityAnimation.toValue = @(1.0);
    }
    
    [topShadowLayer addAnimation:opacityAnimation forKey:nil];
    [bottomShadowLayer addAnimation:opacityAnimation forKey:nil];
    
    [CATransaction commit];

}

- (NSArray *)prepareSplitImage {
    
    CGRect topImageFrame = CGRectMake(0,
                                      0,
                                      self.frame.size.width,
                                      floorf(self.frame.size.height / 2.f));
    
    CGRect bottomImageFrame = CGRectMake(0,
                                         CGRectGetMaxY(topImageFrame),
                                         self.frame.size.width,
                                         ceilf(self.frame.size.height / 2));
    
    UIGraphicsBeginImageContext(self.frame.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *fullViewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(fullViewImage.CGImage, topImageFrame);
    UIImage *topHalf = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    imageRef = CGImageCreateWithImageInRect(fullViewImage.CGImage, bottomImageFrame);
    UIImage *bottomHalf = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    UIImageView *topHalfView = [[UIImageView alloc] initWithImage:topHalf];
    topHalfView.frame = topImageFrame;
    
    UIImageView *bottomHalfView = [[UIImageView alloc] initWithImage:bottomHalf];
    bottomHalfView.frame = bottomImageFrame;
    
    return @[topHalfView, bottomHalfView];


}

@end
