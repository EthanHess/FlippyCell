//
//  ItemController.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "ItemController.h"

@implementation ItemController

+ (ItemController *)sharedInstance {
    static ItemController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ItemController new];
    });
    
    return sharedInstance;
    
}

- (NSArray *)items {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSArray *fetchObjects = [[MOStack sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    
    return fetchObjects;
}

- (void)addItemWithTitle:(NSString *)title andText:(NSString *)desc {
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:[MOStack sharedInstance].managedObjectContext];
    
    item.title = title;
    item.desc = desc;
    
    [self save];
    
}

- (void)removeItem:(Item *)item {
    
    [item.managedObjectContext deleteObject:item];
    
    [self save]; 
    
}

- (void)save {
    
    [[[MOStack sharedInstance]managedObjectContext]save:NULL];
}

@end
