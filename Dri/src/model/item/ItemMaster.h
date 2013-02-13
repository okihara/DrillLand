//
//  Item.h
//  Dri
//
//  Created by  on 12/09/24.
//  Copyright (c) 2012 Hitomitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ITEM_TYPE {
    NONE   = 0,
    SPEND  = 1,
    WEAPON = 2,
};

@interface ItemMaster : NSObject
{
    uint item_id;
    uint atk;
    uint def;
    uint type;
    uint action_id;
}

@end
