//
//  RWTableViewCell.m
//  VerticalTableView
//
//  Created by Ryan Wang on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RWTableViewCell.h"

@implementation RWTableViewCell

@synthesize reuseIdentifier;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)aReuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:aReuseIdentifier];
    if (self) {
        // Initialization code
        self.reuseIdentifier = aReuseIdentifier;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
