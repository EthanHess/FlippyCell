//
//  ItemController.h
//  FlippyCell
//
//  Created by Ethan Hess on 6/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "MOStack.h"

@interface ItemController : NSObject

@property (nonatomic, strong) NSArray *items;

+ (ItemController *)sharedInstance;

- (void)addItemWithTitle:(NSString *)title andText:(NSString *)desc;

- (void)removeItem:(Item *)item;

@end
