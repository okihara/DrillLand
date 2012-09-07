//
//  HelloWorldLayer.m
//  Dri
//
//  Created by  on 12/08/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "DungeonScene.h"
#import "DungeonModel.h"
#import "DungeonView.h"
#import "BlockView.h"

#pragma mark - HelloWorldLayer

#define DISP_H 9

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
     
        // setup dungeon view
        dungeon_view = [DungeonView node];
        [dungeon_view setDelegate:self];
        [self addChild:dungeon_view];
        
        offset_y = 0;
        [self update_curring_range];
        
        // setup dungeon model
        dungeon_model = [[DungeonModel alloc] init:NULL];
        //[dungeon _setup];
        [dungeon_model add_observer:dungeon_view];
        [dungeon_model load_from_file:@"floor001.json"];
        
        BlockView* player = [BlockView create:dungeon_model.player ctx:dungeon_model];  
        player.scale = 2.0;
        [player play_anime:@"walk"];
        
        [dungeon_view add_block:player];
        dungeon_view.player = player;
        [player release];

        
        // ブロック描画
        [dungeon_view update_view:dungeon_model];
        CGPoint p_pos = [dungeon_view model_to_local:dungeon_model.player.pos];
        player.position = p_pos;

        
		// enable touch
        self.isTouchEnabled = YES;
	}
	return self;
}

- (void) dealloc
{
    [dungeon_model release];
    [super dealloc];
}

- (void)render_and_animation
{
    // タップ禁止に
    // need implement
    
    [dungeon_view update_presentation:self->dungeon_model];
    // TODO: スクロールも一連のアクションシーケンスのひとつ
    [self scroll_to];

    // タップ禁止解除
    // need implement
}

- (DLPoint)screen_to_view_pos:(NSSet *)touches
{
    // スクリーン座標からビューの座標へ変換
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location =[[CCDirector sharedDirector] convertToGL:location];
    int x = (int)(location.x / 60);
    int y = (int)((480 - location.y + offset_y) / 60);
    return cdp(x, y);
}

- (void)update_dungeon_view
{
    // アニメーション開始
    [self render_and_animation];
    
    // 更新
    [self->dungeon_view update_view:self->dungeon_model];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{

    DLPoint view_pos = [self screen_to_view_pos:touches];
    
    // モデルへ通知
    [self->dungeon_model on_hit:view_pos];

    // スクロールの offset 更新
    self->offset_y = [self get_offset_y_by_player_pos];
    
    // カリングの幅を更新
    [self update_curring_range];

    
    
    // TODO: ここをシーケンスにしたい
    // TODO: ここからタップ禁止
    NSMutableArray* action_list = [NSMutableArray arrayWithCapacity:5];
  
    CCAction* player_action = [self->dungeon_view get_action_update_player_pos:self->dungeon_model];
    if (player_action) {
        [action_list addObject:player_action];
    }
    
    CCAction* next_action = [CCCallBlockO actionWithBlock:^(DungeonScene* scene) {
        [scene update_dungeon_view];
    } object:self];
    [action_list addObject:next_action];

    
    [self->dungeon_view.player runAction:[CCSequence actionWithArray:action_list]];
}

//===============================================================
//
// スクロール関係
//
//===============================================================

- (float)get_offset_y_by_player_pos
{
    // 一番現在移動できるポイントが中央にくるまでスクロール？
    // プレイヤーの位置が４段目ぐらいにくるよまでスクロール
    // 一度いった時は引き返せない
    int by = (int)(offset_y / 60);
    int diff = self->dungeon_model.player.pos.y - by;
    int hoge = 3;
    if (diff - hoge > 0) {
        offset_y += 60 * (diff - hoge);
    }
    
    // ここらへんはフロアの情報によって決まる
    // current_floor_max_rows * block_height + margin
    int max_scroll = (HEIGHT - DISP_H) * 60 + 30;
    if (offset_y > max_scroll) offset_y = max_scroll;
    
    return offset_y;
}

-(void)scroll_to
{
    // 実際の処理
    CCMoveTo *act_move = [CCMoveTo actionWithDuration: 0.4 position:ccp(0, offset_y)];
    CCEaseInOut *ease = [CCEaseInOut actionWithAction:act_move rate:2];
    [dungeon_view runAction:ease];
}

- (void)update_curring_range
{
    // カリング
    int visible_y = (int)(self->offset_y / 60);
    int curring_var = -1;
    self->dungeon_view.curring_top    = visible_y - curring_var < 0 ? 0 : visible_y - curring_var;
    self->dungeon_view.curring_bottom = visible_y + DISP_H + curring_var > HEIGHT ? HEIGHT : visible_y + DISP_H + curring_var;
}

@end
