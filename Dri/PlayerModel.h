//
//  Player.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject
{
    int hp;
    int exp;
    int atk;
    int def;
    int x;
    int y;
}

@property(nonatomic, readonly) int x;
@property(nonatomic, readonly) int y;

@end
