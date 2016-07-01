//
//  FlippyCell.m
//  FlippyCell
//
//  Created by Ethan Hess on 6/26/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

#import "FlippyCell.h"
#import "UIColor+Colors.h"

@implementation FlippyCell


- (void)awakeFromNib {
    [super awakeFromNib];

    self.withDetails = NO;
    self.backgroundView = nil;
    self.detailContainerViewHeightConstraint.constant = 0;
    
    self.titleContainer.backgroundColor = [UIColor randomOne];
    self.detailContainerView.backgroundColor = [UIColor randomTwo];
    
    self.titleLabel.textColor = [UIColor randomTwo];
    self.descriptionLabel.textColor = [UIColor randomOne]; 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)setWithDetails:(BOOL)withDetails {
    
    _withDetails = withDetails;
    
    if (withDetails) {
        self.detailContainerViewHeightConstraint.priority = 250;
    } else {
        self.detailContainerViewHeightConstraint.priority = 999;
    }
}

- (void)animateOpen {
    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.detailContainerView openWithTransparency:YES
                                   withCompletionBlock:^{
                                       self.contentView.backgroundColor = originalBackgroundColor;
                                   }];
}

- (void)animateClosed {
    UIColor *originalBackgroundColor = self.contentView.backgroundColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.detailContainerView closeWithTransparency:YES withCompletionBlock:^{
        self.contentView.backgroundColor = originalBackgroundColor;
    }];
}

@end
