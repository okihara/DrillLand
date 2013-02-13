//
//  DungeonSceneEventList.m
//  Dri
//
//  Created by okihara on 2013/02/12.
//
//

#import "DungeonSceneEventQueue.h"


@interface DungeonSceneEventQueue ()
- (CCAction*)_animate:(DungeonModel*)dungeonModel
          dungeonView:(DungeonView*)dungeonView;
@end

@implementation DungeonSceneEventQueue

-(id)init
{
	if (self=[super init]) {
        self->eventQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self->eventQueue release];
    [super dealloc];
}

-(void)addObject:(id)target
{
    [self->eventQueue addObject:target];
}

//===============================================================
//
// １ブロックの１ターン毎のアクションを生成
//
//===============================================================

// 全部の今回起こったアクション全てをシーケンスにしたアクションを返す
- (CCAction*)animate:(DungeonModel*)dungeonModel
         dungeonView:(DungeonView*)dungeonView
{
    if (![self->eventQueue count]) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray array];
    
    DLEvent *e = (DLEvent*)[self->eventQueue objectAtIndex:0];
    while (e) {
        
        CCAction *action = [self _animate:dungeonModel dungeonView:dungeonView];
        if (action) {
            [actions addObject:action];
        }
        
        if (![self->eventQueue count]) {
            break;
        }
        e = (DLEvent*)[self->eventQueue objectAtIndex:0];
    }
    
    return [actions count] ? [CCSequence actionWithArray:actions] : nil;
}

// ブロック毎の１ターンのアクションを返す
- (CCAction*)_animate:(DungeonModel*)dungeonModel
          dungeonView:(DungeonView*)dungeonView
{
    if (![self->eventQueue count]) {
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray array];
    
    // 先頭のイベントを取得
    // TODO: 下の処理と被ってる
    DLEvent *e = (DLEvent*)[self->eventQueue objectAtIndex:0];
    [e.params setObject:dungeonModel forKey:@"dungeon_model"];
    
    BlockModel *b = (BlockModel*)e.target;
    
    while (e) {
        
        CCAction *act = [dungeonView notify:dungeonModel event:e];
        if (act) {
            [actions addObject:act];
        }
        
        [self->eventQueue removeObjectAtIndex:0];
        
        if (![self->eventQueue count]) {
            break;
        }
        
        // 先頭のイベントを取得
        // TODO: 上の処理と被ってる
        e = (DLEvent*)[self->eventQueue objectAtIndex:0];
        [e.params setObject:dungeonModel forKey:@"dungeon_model"];
        
        // これどういうこと？？
        if(e.type == DL_ON_HIT) {
            break;
        }
    }
    
    // 描画イベント全部処理して、死んでたら
    CCAction *act_suicide = [CCCallBlock actionWithBlock:^{
        NSLog(@"[SUICIDE] %d %d %d", b.block_id, b.pos.x, b.pos.y);
        [dungeonView remove_block_view_if_dead:b.pos];
    }];
    [actions addObject:act_suicide];
    
    return [actions count] ? [CCSequence actionWithArray:actions] : nil;
}



@end
