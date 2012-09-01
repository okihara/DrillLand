//
//  BlockView.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DungeonModel.h"

@class BlockModel, DungeonView;

@interface BlockView : CCSprite
{
    
}

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx;
-(BOOL)handle_event:(DungeonView*)ctx type:(int)type;
-(void)play_anime:(NSString*)name;

@end
