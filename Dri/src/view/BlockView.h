//
//  BlockView.h
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DungeonModel.h"
#import "DLEvent.h"
#import "DLView.h"

@class BlockModel, DungeonView;
@class BlockView;

@protocol BlockPresentation <NSObject>
-(CCAction*)handle_event:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e view:(BlockView *)view_;
@end

enum VIEW_TYPE {
    VIEW_TYPE_NULL       = 0,
    VIEW_TYPE_BLOCK      = 100,
    VIEW_TYPE_ENEMY      = 200,
    VIEW_TYPE_ITEM_BASIC = 300,
    VIEW_TYPE_ITEM_BOX   = 301,
    VIEW_TYPE_PLAYER     = 900,
    VIEW_TYPE_MESSAGE    = 500,
};

#import "GameObject.h"

@interface BlockView : GameObject
{
    BOOL is_alive;
    BOOL is_change;
    
    NSMutableArray* events;
    NSMutableArray* presentation_list;
    
    DLPoint pos; // これたぶんいらん。updateColor のためだけに使ってる
    uint    direction;
}
@property (readwrite, assign) BOOL is_alive;
@property (readwrite, assign) BOOL is_change;
@property (nonatomic, readwrite) DLPoint pos;

- (void)setup;
- (void)addPresentation:(NSObject<BlockPresentation> *)presentation;
- (CCAction*)handleEvent:(NSObject<ViewContextProtocol> *)ctx event:(DLEvent*)e;
- (CCFiniteTimeAction*)playAnime:(BlockModel *)blockModel name:(NSString *)suffix;

@end
