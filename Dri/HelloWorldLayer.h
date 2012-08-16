//
//  HelloWorldLayer.h
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "TileMap.h"
#import "DungeonModel.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    DungeonModel *dungeon;
    int offset_y;
    int disp_w;
    int disp_h;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void) notify:(DungeonModel*)_dungeon;

@end
