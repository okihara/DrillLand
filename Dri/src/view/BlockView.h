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
@class BlockView;

@protocol BlockPresentation <NSObject>

-(void)handle_event:(DungeonView *)ctx event:(int)event model:(BlockModel*)model_ view:(BlockView *)view_;

@end

@interface BlockView : CCSprite
{
    NSMutableArray* events;
    NSMutableArray* presentation_list;
    BOOL is_alive;
}

+(BlockView *) create:(BlockModel*)b ctx:(DungeonModel*)ctx;
-(BOOL)handle_event:(DungeonView*)ctx type:(int)type model:(BlockModel*)b;
-(void)play_anime:(NSString*)name;
-(void)update_presentation:(DungeonView*)ctx model:(BlockModel*)b;

@property (readwrite, assign) BOOL is_alive;

@end
