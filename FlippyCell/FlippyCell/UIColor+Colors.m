//
//  UIColor+Colors.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)

+ (UIColor *)randomOne {
    
    return [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
}

+ (UIColor *)randomTwo {
    
    return [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];
}

@end
