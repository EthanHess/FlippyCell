//
//  UIView+extend.h
//  FlippyCell
//
//  Created by Ethan Hess on 6/26/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extend)

- (void)openWithTransparency:(BOOL)withTransparency withCompletionBlock:(void (^)(void))completionBlock;

- (void)closeWithTransparency:(BOOL)withTransparency withCompletionBlock:(void (^)(void))completionBlock;

@end
