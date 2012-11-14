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

// 使ってない
enum DL_PHASE {
    DL_ETC = 0,
    DL_MOVE,
    DL_ATTACK,
    DL_DEFENSE,
    DL_DESTROY
};

@interface BlockView : CCSprite
{
    BOOL is_alive;
    BOOL is_change;
    
    NSMutableArray* events;
    NSMutableArray* presentation_list;
    
    uint direction;
    
    // Dictionary になるか？
//    {
//        normal : こういうアニメーションだよぉ,
//        on_hit : ヒット時のアニメーション,
//        on_destroy: 死亡時のアニメーション,
//        on_attack : 攻撃時のアニメーション
//        on_appeared : 出現時のアニメーション,
//        
//    }
}

@property (readwrite, assign) BOOL is_alive;
@property (readwrite, assign) BOOL is_change;

- (void)setup;
- (void)add_presentation:(NSObject<BlockPresentation>*)presentation;

// event
- (CCAction*)handle_event:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e;

// helper
- (void)play_anime:(NSString*)name;
- (CCFiniteTimeAction*)play_anime_one:(NSString*)name;

- (CCAction*)get_action_update_player_pos:(DungeonModel *)_dungeon view:(DungeonView*)view;

// そなえて置くべきメソッド
-(CCFiniteTimeAction*)play_front:(BlockModel*)block_model;
-(CCFiniteTimeAction*)play_attack:(BlockModel*)block_model;

@end
