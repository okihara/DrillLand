//
//  SequenceBuilder.h
//  Dri
//
//  Created by  on 13/02/13.
//  Copyright (c) 2013 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCLayer;
@class DungeonModel;
@class DungeonView;
@class DungeonSceneEventQueue;
@class CCAction;

@interface SequenceBuilder : NSObject

-(CCAction*)build:(CCLayer*)scene 
     dungeonModel:(DungeonModel*)dungeonModel 
      dungeonView:(DungeonView*)dungeonView
       eventQueue:(DungeonSceneEventQueue*)eventQueue;

@end
