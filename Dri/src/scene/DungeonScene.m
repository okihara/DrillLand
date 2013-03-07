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
#import "SequenceBuilder.h"
#import "SaveData.h"


@interface DungeonScene ()
-(void)_runFirstSequece;
-(DLPoint)_mapPosFromTouches:(NSSet *)touches;
@end

@implementation DungeonScene

- (id)initWithDungeonModel:(DungeonModel*)dungeon_model_
{
	if (self=[super init]) {

        // ---------------------------------------------------------------------
        // セットアップ
        // TODO: Scene の Behaivior に移すべきもの
        // ---------------------------------------------------------------------
        srand(time(nil));
        [BasicNotifierView setup:self];
        self->seqBuilder = [[SequenceBuilder alloc] init];
        self->eventQueue = [[DungeonSceneEventQueue alloc] init];

        // setup dungeon model
        self->dungeon_model = dungeon_model_;
        [self->dungeon_model addObserver:self];
        // セーブデータを読み込む
        NSDictionary *saveData = [[SaveData new] get];
        int gold = [[saveData objectForKey:@"gold"] intValue];
        dungeon_model_.player.gold = gold;
        
        
        // ---------------------------------------------------------------------
        // シーン内オブジェクトの構築
        // TODO: JSON から読んで構築するようにする
        // ---------------------------------------------------------------------

        // setup dungeon view
        self->dungeon_view = [DungeonView node];
        [self addChild:dungeon_view];
        // これなにやってるの？
        [dungeon_view update_view:dungeon_model];
        
        // 勇者を初期位置に
        BlockView *player = [BlockViewBuilder build:dungeon_model.player ctx:dungeon_model];
        CGPoint p_pos = [dungeon_view mapPosToViewPoint:cdp(8, 3)];
        player.position = p_pos;
        [dungeon_view add_player:player];
        
        // fade 用のレイヤー
        self->fade_layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 255)];
        [self addChild:self->fade_layer z:10];
        
        // status bar
        self->statusbar = [[StatusBarView alloc] init];
        self->statusbar.position = ccp(320 / 2, 480 - 60 / 2);
        [self addChild:self->statusbar];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGold" object:[NSNumber numberWithInt:dungeon_model_.player.gold]];
        
        // MENU の下に引くレイヤー
        CCLayer *bottomArea = [CCLayerColor layerWithColor:ccc4(0, 25, 0, 255)];
        bottomArea.position = ccp(0, -440);
        [self addChild:bottomArea];
        
        // MENU そのもの
        self->itemItem = [CCMenuItemFont itemWithString:@"[ITEM]" target:self selector:@selector(didPressButton:)];
        self->itemMenu = [CCMenuItemFont itemWithString:@"[MENU]" target:self selector:@selector(didPressButton:)];
        CCMenu *menu = [CCMenu menuWithItems:itemMenu, itemItem, nil];
        menu.position = ccp(210, 20);
        [menu alignItemsHorizontally];
        [self addChild:menu];
        
        
        // ---------------------------------------------------------------------        
        // 構築後に必要な処理
        // TODO: init の中でするものではない
        // ---------------------------------------------------------------------
        [self _runFirstSequece];
	}
	return self;
}

- (void)dealloc
{
    [self->eventQueue release];
    [self->seqBuilder release];
    [self->dungeon_model release];
    [super dealloc];
}


// -----------------------------------------------------------------------------

- (void)_runSequence
{
    // タップ後のシーケンス再生
    CCAction *action = [self->seqBuilder build:self                         
                                  dungeonModel:self->dungeon_model 
                                   dungeonView:self->dungeon_view 
                                    eventQueue:self->eventQueue];
    [self->dungeon_view.player runAction:action];
    
    
    // 死亡フラグついてるブロックをクリア
    // タップ可能範囲をアップデート
    [self->dungeon_model postprocess];
}

// -----------------------------------------------------------------------------
// Behavior
// -----------------------------------------------------------------------------
- (void)_handleStateNormal:(NSSet *)touches
{
    // モデルへ通知
    DLPoint pos = [self _mapPosFromTouches:touches];
    BOOL changed = [self->dungeon_model onTap:pos];
    
    if (!changed) { return; }
    
    [self _runSequence];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    uint state = 0;
    
    switch (state) {
            
        case 0:
            [self _handleStateNormal:touches];
            break;
            
        case 1:
            // クリア時のステート
            break;
            
        default:
            break;
    }
}


// -----------------------------------------------------------------------------
// ゲーム内イベントのハンドラ
- (void)notify:(DungeonModel *)dungeon_ event:(DLEvent *)event
{
    BlockModel *block = event.target;
    
    NSLog(@"[EVENT] block:%05d %@\t%@ %@", block.block_id, [NSValue valueWithCGPoint:ccp(block.pos.x, block.pos.y)], [event get_event_text], event.params);
    
    switch (event.type) {
            
        case DL_ON_CANNOT_TAP:
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
        {
            [BasicNotifierView notify:@"HP GA 10 KAIFUKU!" target:self];
            [self->eventQueue addObject:event];
            break;
        }

        case DL_ON_GET:
        {
            UserItem *userItem = [event.params objectForKey:@"UserItem"];
            NSString *strGot = [NSString stringWithFormat:@"You got %@", userItem.name];
            [BasicNotifierView notify:strGot target:self];
            [self->eventQueue addObject:event];
        }
            break;
            
        case DL_ON_UPDATE:
            [self _runSequence];
            break;
            
        default:
            [self->eventQueue addObject:event];
            break;
    }
}

// -----------------------------------------------------------------------------
// メニューボタン押した時のハンドラ
- (void)didPressButton:(CCMenuItem *)sender
{
    if (sender == self->itemMenu) {
        // MENU に飛ばす
        CCScene *scene = [DungeonMenuScene scene];
        [[CCDirector sharedDirector] pushScene:scene];
        return;
    }
    
    if (sender == self->itemItem) {
        // INVENTORY に飛ばす
        CCScene *scene = [InventoryScene scene:self->dungeon_model];
        [[CCDirector sharedDirector] pushScene:scene];
        return;
    }
}


// -----------------------------------------------------------------------------
// Private Methods
// -----------------------------------------------------------------------------

- (DLPoint)_mapPosFromTouches:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    return [self->dungeon_view viewPointToMapPos:location];
}

- (void)_doScroll
{
    [self->dungeon_view update_offset_y:self->dungeon_model.lowest_empty_y - 1];
    [self->dungeon_view scroll_to];
}

- (void)_runFirstSequece {
    
    if (0) {
        // FADE OUT
        CCFiniteTimeAction *fi = [CCFadeOut actionWithDuration:0.1f];
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
    CGPoint p_pos = [dungeon_view mapPosToViewPoint:cdp(3,3)];
    CCAction* action_1 = [CCMoveTo actionWithDuration:2.0 position:p_pos];
    [dungeon_view.player runAction:[CCSequence actions:nl, action_1, [CCCallBlock actionWithBlock:^(){
        self.isTouchEnabled = YES;
    }], nil]];
}

+ (CCScene *)sceneWithDungeonModel:(DungeonModel*)dungeon_model
{
	CCScene *scene = [CCScene node];
	CCLayer *layer = [[[DungeonScene alloc] initWithDungeonModel:dungeon_model] autorelease];
	[scene addChild:layer];
	return scene;
}

@end
