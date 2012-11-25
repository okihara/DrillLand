//
//  HelloWorldLayer.m
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "DL.h"
#import "DungeonScene.h"
#import "DungeonModel.h"
#import "DungeonView.h"
#import "BlockView.h"
#import "BlockViewBuilder.h"
#import "BasicNotifierView.h"
#import "DungeonResultScene.h"
#import "DungeonMenuScene.h"

// HelloWorldLayer implementation
@implementation DungeonScene


// -----------------------------------------------------------------------------
// 最初のシーケンス
- (void)run_first_sequece {
    
    // FADE OUT
    CCFiniteTimeAction* fi = [CCFadeOut actionWithDuration:2.0];
    [self->fade_layer runAction:fi];
    
    // ダンジョン名表示
    self->large_notify = [[LargeNotifierView alloc] init];
    [self addChild:self->large_notify];
    
    // 勇者がてくてく歩く
    CCActionInterval* nl = [CCDelayTime actionWithDuration:2.0];
    CGPoint p_pos = [dungeon_view model_to_local:cdp(2,3)];
    CCAction* action_1 = [CCMoveTo actionWithDuration:2.0 position:p_pos];
    [dungeon_view.player runAction:[CCSequence actions:nl, action_1, [CCCallBlock actionWithBlock:^(){
        self.isTouchEnabled = YES;
    }], nil]];
}


// -----------------------------------------------------------------------------
// 初期化
+ (CCScene *)sceneWithDungeonModel:(DungeonModel*)dungeon_model
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [[[DungeonScene alloc] initWithDungeonModel:dungeon_model] autorelease];
	[scene addChild: layer];
	return scene;
}

- (id) initWithDungeonModel:(DungeonModel*)dungeon_model_
{
	if( (self=[super init]) ) {
        
        // 乱数初期化
        srand(time(nil));
        
        //
        self->events = [[NSMutableArray array] retain];
     
        // setup dungeon view
        dungeon_view = [DungeonView node];
        [self addChild:dungeon_view];
        
        // calc curring
        [self->dungeon_view update_curring_range];
        
        // setup dungeon model
        self->dungeon_model = dungeon_model_;
        [self->dungeon_model add_observer:self];

        // setup player
        BlockView* player = [BlockViewBuilder build:dungeon_model.player ctx:dungeon_model];
        [dungeon_view add_block:player];
        dungeon_view.player = player;
        [player release];

        // 勇者を初期位置に
        [dungeon_view update_view:dungeon_model];
        CGPoint p_pos = [dungeon_view model_to_local:cdp(5,3)];
        player.position = p_pos;
        
        // fade 用のレイヤー
        self->fade_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        [self addChild:self->fade_layer z:10];
        
        // status bar
        self->statusbar = [[StatusBarView alloc]init];
        self->statusbar.position = ccp(320 / 2, 480 - 60 / 2);
        [self addChild:self->statusbar];
        
        // menu
        //CCSprite *spr_menu = [CCSprite spriteWithFile:@"block01.png"];
        //CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:spr_menu selectedSprite:spr_menu target:self selector:@selector(didPressButton:)];
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

- (void) dealloc
{
    [dungeon_model release];
    [super dealloc];
}

// -----------------------------------------------------------------------------
// メニューボタン押した時のハンドラ
- (void)didPressButton:(CCMenuItem *)sender
{
    CCScene *scene = [DungeonMenuScene scene];
    [[CCDirector sharedDirector] pushScene:scene];
}

//===============================================================
//
// １ブロックの１ターン毎のアクションを生成
// TODO: 別クラス化
//
//===============================================================

// ブロック毎の１ターンのアクションを返す
- (CCAction*)_animate
{
    // ガード
    if (![self->events count]) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray array];
    
    // 先頭のイベントを取得
    // TODO: 下の処理と被ってる
    DLEvent *e = (DLEvent*)[self->events objectAtIndex:0];
    [e.params setObject:self->dungeon_model forKey:@"dungeon_model"];
    
    BlockModel *b = (BlockModel*)e.target;
    
    while (e) {
        
        CCAction *act = [self->dungeon_view notify:self->dungeon_model event:e];
        if (act) {
            [actions addObject:act];
        }
        
        [self->events removeObjectAtIndex:0];
        
        if (![self->events count]) {
            break;
        }
        
        // 先頭のイベントを取得
        // TODO: 上の処理と被ってる
        e = (DLEvent*)[self->events objectAtIndex:0];
        [e.params setObject:self->dungeon_model forKey:@"dungeon_model"];
        
        // これどういうこと？？
        if( e.type == DL_ON_HIT ) {
            break;
        }
    }
    
    // 描画イベント全部処理して、死んでたら
    CCAction *act_suicide = [CCCallBlock actionWithBlock:^{
        NSLog(@"[SUICIDE] %d %d %d", b.block_id, b.pos.x, b.pos.y);
        [self->dungeon_view remove_block_view_if_dead:b.pos];
    }];
    [actions addObject:act_suicide];
    
    if ([actions count]) {
        return [CCSequence actionWithArray:actions];
    } else {
        return nil;
    }
    
}

// 全部の今回起こったアクション全てをシーケンスにしたアクションを返す
- (CCAction*)animate
{
    // ガード
    if (![self->events count]) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray array];
    
    DLEvent *e = (DLEvent*)[self->events objectAtIndex:0];
    while (e) {
        
        CCAction *action = [self _animate];
        if (action) {
            [actions addObject:action];
        }
        
        if (![self->events count]) {
            break;
        }
        e = (DLEvent*)[self->events objectAtIndex:0];
    }
    
    if (actions) {
        return [CCSequence actionWithArray:actions];
    } else {
        return nil;
    }
}


//===============================================================
//
// タッチ後のシーケンス
//
//===============================================================

- (void)run_sequence
{
    // -------------------------------------------------------------------------------    
    // シーケンス再生中はタップ不可
    self.isTouchEnabled = NO;
    
    // アクションのシーケンスを作成
    NSMutableArray* action_list = [NSMutableArray array];
    
    // -------------------------------------------------------------------------------
    // プレイヤーの移動フェイズ(ブロックの移動フェイズ)
    CCAction* act_player_move = [self->dungeon_view.player get_action_update_player_pos:self->dungeon_model view:self->dungeon_view];
    if (act_player_move) {
        [action_list addObject:act_player_move];
    }
    
    // -------------------------------------------------------------------------------
    // プレイヤーを中心にして、ブロックの明るさを変える
    [self->dungeon_view update_block_color:dungeon_model center_pos:self->dungeon_model.player.pos];

    
    // -------------------------------------------------------------------------------    
    // ブロック毎のターン処理
    // アニメーション開始
    CCAction *act_animate = [self animate];
    NSLog(@"act_animate %@", act_animate);
    if (act_animate) {
        [action_list addObject:act_animate];
    }
    
    // -------------------------------------------------------------------------------
    // TODO: これは入れるのか？？
    // エネミー死亡エフェクトフェイズ(相手のブロックの死亡フェイズ)
    // エネミーチェンジフェイズ
    
    // -------------------------------------------------------------------------------
    // 画面の描画
    CCAction* act_update_view = [CCCallFuncO actionWithTarget:self->dungeon_view selector:@selector(update_dungeon_view:) object:self->dungeon_model];
    [action_list addObject:act_update_view];
    
    // -------------------------------------------------------------------------------
    // スクロールフェイズ
    CCAction *act_scroll = [CCCallFuncO actionWithTarget:self selector:@selector(do_scroll)];
    [action_list addObject:act_scroll];
    
    // -------------------------------------------------------------------------------
    // タッチをオンに
    CCAction* act_to_touchable = [CCCallBlockO actionWithBlock:^(DungeonScene* this) {
        this.isTouchEnabled = YES;
    } object:self];
    [action_list addObject:act_to_touchable];
    
    // -------------------------------------------------------------------------------    
    // 実行
    [self->dungeon_view.player runAction:[CCSequence actionWithArray:action_list]];
}


//===============================================================
//
// タッチのハンドラ
//
//===============================================================

- (DLPoint)_screen_to_view_pos:(CGPoint)location
{
    // TODO: ここから先 DungeonView に移動するべき
    // ↑ ほんとうか？
    // model_to_local の反対
    int x = (int)(location.x / BLOCK_WIDTH);
    int y = (int)((480 - location.y + self->dungeon_view.offset_y) / BLOCK_WIDTH);
    return cdp(x, y);
}

// HELPER: スクリーン座標からビューの座標へ変換
- (DLPoint)screen_to_view_pos:(NSSet *)touches
{
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    
    return [self _screen_to_view_pos:location];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    uint state = 0;
    
    switch (state) {
            
        case 0:
        {
            // モデルへ通知
            BOOL changed = [self->dungeon_model on_hit:[self screen_to_view_pos:touches]];
            
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
    // スクロールの offset 更新
    [self->dungeon_view update_offset_y:self->dungeon_model.lowest_empty_y - 1];
    
    // 実際にスクロールさせる
    [self->dungeon_view scroll_to];
}


//===============================================================
//
// イベントハンドラ
//
//===============================================================

-(void)notify:(DungeonModel *)dungeon_ event:(DLEvent *)event
{
    BlockModel *block = event.target;
    
    NSLog(@"[EVENT] block:%05d %@\t%@ %@", block.block_id, [NSValue valueWithCGPoint:ccp(block.pos.x, block.pos.y)], [event get_event_text], event.params);
    
    switch (event.type) {
            
        case DL_ON_CANNOT_TAP:
            [BasicNotifierView notify:@"CAN NOT TAP" target:self];
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
            [self->events addObject:event];
            break;

        case DL_ON_GET:
            [BasicNotifierView notify:@"You got Dorayaki(S)" target:self];
            [self->events addObject:event];
            break;
            
        default:
            [self->events addObject:event];
            break;
    }
}

@end
