//
//  Player.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"
#import "XDMap.h"

@interface PlayerModel : NSObject
{
    int hp;
    int exp;
    int atk;
    int def;
    DLPoint pos;
}

@property(nonatomic, readonly) DLPoint pos;

@end
