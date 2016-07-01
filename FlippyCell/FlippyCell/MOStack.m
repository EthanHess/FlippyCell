//
//  MOStack.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "MOStack.h"

@interface MOStack()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation MOStack

+ (MOStack *)sharedInstance {
    static MOStack *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MOStack new];
    });
    
    return sharedInstance;
    
}

- (id)init {
    
    self = [super init];
    if (self) {
        [self setUpMOC];
    }
    
    return self;
}

- (void)setUpMOC {
    
    self.managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError* error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:self.storeURL
                                                                             options:nil
                                                                               error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSURL *)storeURL {
    
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    return [documentsDirectory URLByAppendingPathComponent:@"db.sqlite"];
}

- (NSURL *)modelURL {
    
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    
}

@end
