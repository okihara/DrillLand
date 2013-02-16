//
//  Item.h
//  Dri
//
//  Created by  on 12/09/24.
//  Copyright (c) 2012 Hitomitsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//enum ITEM_TYPE {
//    NONE   = 0,
//    SPEND  = 1,
//    WEAPON = 2
//};

@interface ItemMaster : NSObject
{
    NSString *name;
    uint item_id;
    uint type;
    uint atk;
    uint def;
    uint action_id;
    BOOL canEquip;
}

@end
