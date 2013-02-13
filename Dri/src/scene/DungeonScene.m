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


@interface DungeonScene ()
-(void)_runFirstSequece;
-(DLPoint)_mapPosFromTouches:(NSSet *)touches;
@end

@implementation DungeonScene

- (id)initWithDungeonModel:(DungeonModel*)dungeon_model_
{
	if (self=[super init]) {
        
        // 乱数初期化
        srand(time(nil));
        
        self->seqBuilder = [[SequenceBuilder alloc] init];
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
        
        [self _runFirstSequece];
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
    [self->dungeon_model release];
    [self->seqBuilder release];
    [super dealloc];
}


// -----------------------------------------------------------------------------


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    DLPoint pos = [self _mapPosFromTouches:touches];
//    //[self->dungeon_view on_touch_start:pos];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    DLPoint pos = [self _mapPosFromTouches:touches];
//    [self->dungeon_view on_touch_start:pos];
}

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


@end
