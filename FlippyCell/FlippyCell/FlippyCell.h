//
//  FlippyCell.h
//  FlippyCell
//
//  Created by Ethan Hess on 6/26/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+extend.h"

@interface FlippyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIView *detailContainerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailContainerViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *titleContainer;



@property (nonatomic, assign) BOOL withDetails;

- (void)animateOpen;
- (void)animateClosed;

@end
