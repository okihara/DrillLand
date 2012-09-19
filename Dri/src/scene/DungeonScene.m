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
#import "DamageNumView.h"
#import "DungeonResultScene.h"


// HelloWorldLayer implementation
@implementation DungeonScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [DungeonScene node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
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
        dungeon_model = [[DungeonModel alloc] init:NULL];
        [dungeon_model add_observer:self];
        [dungeon_model load_from_file:@"floor001.json"];

        // setup player
        BlockView* player = [BlockViewBuilder create:dungeon_model.player ctx:dungeon_model];  
        [dungeon_view add_block:player];
        dungeon_view.player = player;
        [player release];

        // 勇者を初期位置に
        [dungeon_view update_view:dungeon_model];
        CGPoint p_pos = [dungeon_view model_to_local:cdp(5,1)];
        player.position = p_pos;
        
        // fade 用のレイヤー
        self->fade_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        [self addChild:self->fade_layer z:10];
        
        // status bar
        self->statusbar = [[StatusBarView alloc]init];
        self->statusbar.position = ccp(320 / 2, 480 - 60 / 2);
        [self addChild:self->statusbar];
	}
	return self;
}

- (void) dealloc
{
    [dungeon_model release];
    [super dealloc];
}

// シーン遷移後のアニメーション
- (void)onEnter
{
    [super onEnter];
    
    // FADE OUT
    CCFiniteTimeAction* fi = [CCFadeOut actionWithDuration:2.0];
    [self->fade_layer runAction:fi];

    // ダンジョン名表示
    self->large_notify = [[LargeNotifierView alloc] init];
    [self addChild:self->large_notify];

    // 勇者がてくてく歩く
    CCActionInterval* nl = [CCDelayTime actionWithDuration:2.0];
    CGPoint p_pos = [dungeon_view model_to_local:cdp(2,1)];
    CCAction* action_1 = [CCMoveTo actionWithDuration:2.0 position:p_pos];
    [dungeon_view.player runAction:[CCSequence actions:nl, action_1, [CCCallBlock actionWithBlock:^(){
        self.isTouchEnabled = YES;
    }], nil]];

    //self.isTouchEnabled = YES;
}


//===============================================================
//
// タッチのハンドラ
//
//===============================================================

// HELPER: スクリーン座標からビューの座標へ変換
- (DLPoint)screen_to_view_pos:(NSSet *)touches
{
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    int x = (int)(location.x / BLOCK_WIDTH);
    int y = (int)((480 - location.y + self->dungeon_view.offset_y) / BLOCK_WIDTH);
    return cdp(x, y);
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    // モデルへ通知
    [self->dungeon_model on_hit:[self screen_to_view_pos:touches]];
    
    // タップ後のシーケンス再生
    [self run_sequence];
}


//===============================================================
//
// タッチ後のシーケンス
//
//===============================================================

- (void)run_sequence
{
    // アクションのシーケンスを作成
    NSMutableArray* action_list = [NSMutableArray arrayWithCapacity:10];
    
    // 
    self.isTouchEnabled = NO;
    
    // -------------------------------------------------------------------------------
    // プレイヤーの移動フェイズ(ブロックの移動フェイズ)
    CCAction* act_player_move = [self->dungeon_view.player get_action_update_player_pos:self->dungeon_model view:self->dungeon_view];
    if (act_player_move) {
        [action_list addObject:act_player_move];
    }
    
    // -------------------------------------------------------------------------------    
    // ブロック毎のターン処理
    // アニメーション開始
    CCAction *act_animate = [self animate];
    NSLog(@"act_animate %@", act_animate);
    if (act_animate) {
        [action_list addObject:act_animate];
    }
    
    // -------------------------------------------------------------------------------
    // エネミー死亡エフェクトフェイズ(相手のブロックの死亡フェイズ)
    // エネミーチェンジフェイズ
    
    // -------------------------------------------------------------------------------
    // スクロールフェイズ
    CCAction *act_scroll = [CCCallFuncO actionWithTarget:self selector:@selector(do_scroll)];
    [action_list addObject:act_scroll];
    
    // -------------------------------------------------------------------------------
    // 画面の描画
    CCAction* act_update_view = [CCCallFuncO actionWithTarget:self->dungeon_view selector:@selector(update_dungeon_view:) object:self->dungeon_model];
    [action_list addObject:act_update_view];
    
    // -------------------------------------------------------------------------------
    // タッチをオンに
    CCAction* act_to_touchable = [CCCallBlockO actionWithBlock:^(DungeonScene* this) {
        this.isTouchEnabled = YES;
    } object:self];
    [action_list addObject:act_to_touchable];
    
    // 実行
    [self->dungeon_view.player runAction:[CCSequence actionWithArray:action_list]];
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
    DLEvent *e = (DLEvent*)[self->events objectAtIndex:0];

    BlockModel *b = (BlockModel*)e.target;
    
    while (e) {
        
        NSLog(@"[EVENT_N] type:%d", e.type);
        CCAction *act = [self->dungeon_view notify:self->dungeon_model event:e];
        if (act) {
            [actions addObject:act];
        }

        [self->events removeObjectAtIndex:0];
        
        
        if (![self->events count]) {
            break;
        }
        e = (DLEvent*)[self->events objectAtIndex:0];
        if( e.type == DL_ON_HIT ) {
            break;
        }
        
    }

    // 描画イベント全部処理して、死んでたら
    CCAction *act_suicide = [CCCallBlock actionWithBlock:^{
        NSLog(@"[SUICIDE] %d %d", b.pos.x, b.pos.y);
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
// スクロール関係
//
//===============================================================

- (void)do_scroll
{
    // プレイヤーの一個下のブロックが空なら
    // スクロールする
    DLPoint ppos = self->dungeon_model.player.pos;
    DLPoint under_pos = cdp(ppos.x, ppos.y + 1);
    BlockModel* b = [self->dungeon_model get:under_pos];
    if (b.type == ID_EMPTY) {
//    if (YES) {
        // スクロールの offset 更新
        [self->dungeon_view update_offset_y: self->dungeon_model.player.pos.y];
        // 実際にスクロールさせる
        [self->dungeon_view scroll_to];
    }
}


//===============================================================
//
// イベントハンドラ
//
//===============================================================

-(void)notify:(DungeonModel *)dungeon_ event:(DLEvent *)event
{
    NSLog(@"[EVENT] type:%d", event.type);
    
    switch (event.type) {
            
        case DL_ON_CANNOT_TAP:
            [BasicNotifierView notify:@"CAN NOT TAP" target:self];
            break;
            
        case DL_ON_CLEAR:
            [[CCDirector sharedDirector] replaceScene:[DungeonResultScene scene]];
            break;
            
        case DL_ON_HEAL:
            [BasicNotifierView notify:@"HP GA 10 KAIFUKU!" target:self];
            [self->events addObject:event];
            break;
            
        default:
            [self->events addObject:event];
            break;
    }
}

@end
