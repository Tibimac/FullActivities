//
//  UICheckboxButton.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 25/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "UICheckboxButton.h"

@implementation UICheckboxButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setFrame:CGRectMake(10, 11, 22, 22)];
    }
    return self;
}


- (void)configureCheckboxButtonWithPriority:(NSUInteger)priority
                               forIndexPath:(NSIndexPath *)indexPath
                            inCellContainer:(UITableViewCell *)cellContainer
{
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"checkbox-checked0-priority%ld", (signed long)priority]]
          forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:[NSString stringWithFormat:@"checkbox-checked1-priority%ld", (signed long)priority]]
          forState:UIControlStateSelected];
    
    [self setIndexPathCell:indexPath];
    [self setCellContainer:cellContainer];
}

@end
