//
//  InventoryMenuItem.m
//  Dri
//
//  Created by  on 13/02/13.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "InventoryMenuItem.h"
#import "UserItem.h"

@implementation InventoryMenuItem

@synthesize userItem;
@synthesize isSelected;

-(id)initWithUserItem:(UserItem*)userItem_ target:(id)r selector:(SEL)s
{
    NSString *strItem = [NSString stringWithFormat:@"%d %@", userItem_.unique_id, userItem_.name];

	if(self=[super initWithString:strItem target:r selector:s]) {
        self->userItem = userItem_;
    }
	return self;
}

-(void)setIsSelected:(BOOL)selected
{
    self->isSelected = selected;
    if (self->isSelected) {
        [self setColor:ccc3(255, 0, 0)];
    } else {
        [self setColor:ccc3(255, 255, 255)];
    }
}

-(BOOL)onTap
{
    if (self.isSelected) {
        return YES;
    } else {
        self.isSelected = YES;
        return NO;
    }
}

@end
