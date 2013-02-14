//
//  InventoryMenuItem.h
//  Dri
//
//  Created by  on 13/02/13.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import "cocos2d.h"

@class UserItem;

@interface InventoryMenuItem : CCMenuItemFont
{
    UserItem *userItem;
    BOOL     isSelected;
}
@property (nonatomic, readonly)  UserItem *userItem;
@property (nonatomic, readwrite) BOOL     isSelected;

-(id)initWithUserItem:(UserItem*)userItem_ target:(id)r selector:(SEL)s;
-(BOOL)onTap;

@end
