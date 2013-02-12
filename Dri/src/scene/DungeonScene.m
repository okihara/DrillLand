//
//  HelloWorldLayer.m
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright Hiromitsu 2012. All rights reserved.
//

#import "DL.h"
#import "DungeonScene.h"
#import "DungeonModel.h"
#import "DungeonView.h"
#import "BlockView.h"
#import "BlockViewBuilder.h"
#import "BasicNotifierView.h"
#import "DungeonResultScene.h"
#import "DungeonMenuScene.h"
#import "InventoryScene.h"
#import "MyItems.h"
#import "UserItem.h"


@implementation DungeonScene

- (id)initWithDungeonModel:(DungeonModel*)dungeon_model_
{
	if (self=[super init]) {
        
        // 乱数初期化
        srand(time(nil));
        
        //
        self->eventQueue = [[DungeonSceneEventQueue alloc] init];
     
        // setup dungeon view
        dungeon_view = [DungeonView node];
        [self addChild:dungeon_view];
        
        // calc curring
        //[self->dungeon_view update_curring_range];
        
        // setup dungeon model
        self->dungeon_model = dungeon_model_;
        [self->dungeon_model addObserver:self];

        // setup player
        BlockView* player = [BlockViewBuilder build:dungeon_model.player ctx:dungeon_model];
        [dungeon_view add_player:player];
        dungeon_view.player = player;
        [player release];

        // 勇者を初期位置に
        [dungeon_view update_view:dungeon_model];
        CGPoint p_pos = [dungeon_view mapPosToViewPoint:cdp(5,3)];
        player.position = p_pos;
        
        // fade 用のレイヤー
        self->fade_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        [self addChild:self->fade_layer z:10];
        
        // status bar
        self->statusbar = [[StatusBarView alloc]init];
        self->statusbar.position = ccp(320 / 2, 480 - 60 / 2);
        [self addChild:self->statusbar];
        
        // menu
        CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"[ITEM]" target:self selector:@selector(didPressButton:)];
        CCMenu *menu = [CCMenu menuWithItems:item, nil];
        menu.position = ccp(240, 450);
        [menu alignItemsVertically];        
        [self addChild:menu];
        
        // --
        [BasicNotifierView setup:self];
        
        [self run_first_sequece];
	}
	return self;
}

+ (CCScene *)sceneWithDungeonModel:(DungeonModel*)dungeon_model
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [[[DungeonScene alloc] initWithDungeonModel:dungeon_model] autorelease];
	[scene addChild:layer];
	return scene;
}

- (void)dealloc
{
    [dungeon_model release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
// 最初のシーケンス
- (void)run_first_sequece {
    
    if (1) {
        // FADE OUT
        CCFiniteTimeAction* fi = [CCFadeOut actionWithDuration:0.1f];
        [self->fade_layer runAction:fi];
        self.isTouchEnabled = YES;
        return;
    }
    
    // FADE OUT
    CCFiniteTimeAction* fi = [CCFadeOut actionWithDuration:2.0];
    [self->fade_layer runAction:fi];
    
    // ダンジョン名表示
    self->large_notify = [[LargeNotifierView alloc] init];
    [self addChild:self->large_notify];
    
    // 勇者がてくてく歩く
    CCActionInterval* nl = [CCDelayTime actionWithDuration:2.0];
    CGPoint p_pos = [dungeon_view mapPosToViewPoint:cdp(2,3)];
    CCAction* action_1 = [CCMoveTo actionWithDuration:2.0 position:p_pos];
    [dungeon_view.player runAction:[CCSequence actions:nl, action_1, [CCCallBlock actionWithBlock:^(){
        self.isTouchEnabled = YES;
    }], nil]];
}

//==============================================================================
//
// タッチ後のシーケンス
//
//==============================================================================

- (void)enableTouch
{
    self.isTouchEnabled = YES;
}

- (void)run_sequence
{
    // -------------------------------------------------------------------------
    // シーケンス再生中はタップ不可
    self.isTouchEnabled = NO;
    
    // アクションのシーケンスを作成
    NSMutableArray *action_list = [NSMutableArray array];
    
    // -------------------------------------------------------------------------
    // プレイヤーの移動フェイズ(ブロックの移動フェイズ)
    CCAction *act_player_move = [self->dungeon_view.player get_action_update_player_pos:self->dungeon_model view:self->dungeon_view];
    if (act_player_move) {
        [action_list addObject:act_player_move];
    }
    
    // -------------------------------------------------------------------------
    // プレイヤーを中心にして、ブロックの明るさを変える
    [self->dungeon_view update_block_color:dungeon_model center_pos:self->dungeon_model.player.pos];

    
    // -------------------------------------------------------------------------
    // ブロック毎のターン処理
    // アニメーション開始
    CCAction *act_animate = [self->eventQueue animate:self->dungeon_model
                                          dungeonView:self->dungeon_view];
    NSLog(@"act_animate %@", act_animate);
    if (act_animate) {
        [action_list addObject:act_animate];
    }
    
    // -------------------------------------------------------------------------
    // TODO: これは入れるのか？？
    // エネミー死亡エフェクトフェイズ(相手のブロックの死亡フェイズ)
    // エネミーチェンジフェイズ
    
    // -------------------------------------------------------------------------
    // 画面の描画
    CCAction *act_update_view = [CCCallFuncO actionWithTarget:self->dungeon_view selector:@selector(update_dungeon_view:) object:self->dungeon_model];
    [action_list addObject:act_update_view];
    
    // -------------------------------------------------------------------------
    // スクロールフェイズ
    CCAction *act_scroll = [CCCallFuncO actionWithTarget:self selector:@selector(do_scroll)];
    [action_list addObject:act_scroll];

    // -------------------------------------------------------------------------
    // 現在の階層を更新
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"UpdateFloor" object:[NSNumber numberWithInt:(self->dungeon_model.lowest_empty_y - 4)]];

    
    // -------------------------------------------------------------------------
    // タッチをオンに
    CCAction *act_to_touchable = [CCCallFuncO actionWithTarget:self selector:@selector(enableTouch)];
    [action_list addObject:act_to_touchable];
    
    // -------------------------------------------------------------------------
    // 実行
    [self->dungeon_view.player runAction:[CCSequence actionWithArray:action_list]];
}


//==============================================================================
//
// タッチのハンドラ
//
//==============================================================================

// HELPER: スクリーン座標からビューの座標へ変換
- (DLPoint)screen_to_view_pos:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    return [self->dungeon_view viewPointToMapPos:location];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLPoint pos = [self screen_to_view_pos:touches];
    [self->dungeon_view on_touch_start:pos];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    DLPoint pos = [self screen_to_view_pos:touches];
    [self->dungeon_view on_touch_start:pos];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    uint state = 0;
    
    switch (state) {
            
        case 0:
        {
            // モデルへ通知
            BOOL changed = [self->dungeon_model onTap:[self screen_to_view_pos:touches]];
            if (!changed) { return; }
            
            // タップ後のシーケンス再生
            [self run_sequence];
            
            // 死亡フラグついてるブロックをクリア
            // タップ可能範囲をアップデート
            [self->dungeon_model postprocess];
        }
            break;
            
        case 1:
        {
            // クリア時のステート
        }
            break;
            
        default:
            break;
    }
}


//===============================================================
//
// スクロール関係
//
//===============================================================

- (void)do_scroll
{
    [self->dungeon_view update_offset_y:self->dungeon_model.lowest_empty_y - 1];
    [self->dungeon_view scroll_to];
}


//===============================================================
//
// イベントハンドラ
//
//===============================================================

- (void)notify:(DungeonModel *)dungeon_ event:(DLEvent *)event
{
    BlockModel *block = event.target;
    
    NSLog(@"[EVENT] block:%05d %@\t%@ %@", block.block_id, [NSValue valueWithCGPoint:ccp(block.pos.x, block.pos.y)], [event get_event_text], event.params);
    
    switch (event.type) {
            
        case DL_ON_CANNOT_TAP:
//            [BasicNotifierView notify:@"CAN NOT TAP" target:self];
            break;
            
        case DL_ON_CLEAR:
        {

            CCCallBlock *goto_result = [CCCallBlock actionWithBlock:^(){
                CCScene *next_scene = [DungeonResultScene scene];
                CCTransitionFade *trans = [CCTransitionFade transitionWithDuration:3.0 scene:next_scene withColor:ccc3(0, 0, 0)];
                [[CCDirector sharedDirector] replaceScene:trans];
            }];
            [BasicNotifierView notify:@"QUEST CLEAR" target:self duration:3.0f];
            CCDelayTime *delay = [CCDelayTime actionWithDuration:7.0f];
            [self runAction:[CCSequence actions:delay, goto_result, nil]];
        }
            break;
            
        case DL_ON_HEAL:
            [BasicNotifierView notify:@"HP GA 10 KAIFUKU!" target:self];
            [self->eventQueue addObject:event];
            break;

        case DL_ON_GET:
            [BasicNotifierView notify:@"You got Dorayaki(S)" target:self];
            [self->eventQueue addObject:event];
            break;
            
        default:
            [self->eventQueue addObject:event];
            break;
    }
}

// -----------------------------------------------------------------------------
// メニューボタン押した時のハンドラ
// -----------------------------------------------------------------------------
- (void)didPressButton:(CCMenuItem *)sender
{
    if (NO) {
        // MENU に飛ばす
        CCScene *scene = [DungeonMenuScene scene];
        [[CCDirector sharedDirector] pushScene:scene];
    } else {
        // INVENTORY に飛ばす
        CCScene *scene = [InventoryScene scene:self->dungeon_model];
        [[CCDirector sharedDirector] pushScene:scene];
    }
}


@end
