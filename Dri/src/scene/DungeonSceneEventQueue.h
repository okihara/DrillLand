//
//  DungeonSceneEventList.h
//  Dri
//
//  Created by okihara on 2013/02/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DLEvent.h"
#import "DungeonView.h"
#import "DungeonModel.h"
#import "BlockModel.h"

@interface DungeonSceneEventQueue : NSObject
{
    NSMutableArray *eventQueue;
}

-(void)addObject:(id)addend;
-(CCAction*)animate:(DungeonModel*)dungeonModel
         dungeonView:(DungeonView*)dungeonView;

@end
