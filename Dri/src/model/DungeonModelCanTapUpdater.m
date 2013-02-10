//
//  DungeonModelImpl.m
//  Dri
//
//  Created by okihara on 2013/02/10.
//
//

#import "DungeonModelCanTapUpdater.h"
#import "DungeonModel.h"

@implementation DungeonModelCanTapUpdater

@synthesize lowestEmptyY;

- (id)init
{
    if (self = [super init]) {
        self->lowestEmptyY = INITIAL_LOWEST_EMPTY_Y;
        self->doneMap = [[XDMap alloc] init];
    }
    return self;
}

-(void)clearCanTap:(ObjectXDMap*)map
{
    for (int j = 0; j < DM_HEIGHT; j++) {
        for (int i = 0; i < DM_WIDTH; i++) {
            BlockModel *b = [map get_x:i y:j];
            b.can_tap = NO;
        }
    }
}

-(void)updateCanTap:(ObjectXDMap*)map start:(DLPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    // 起点は 0 でなければならない
    BlockModel* b = [map get_x:x y:y];
    if ( b.block_id > 0 ) return;
    
    // 操作済み判別テーブルを初期化
    [self->doneMap clear];
    
    // タップ可能かどうかを初期化
    [self clearCanTap:map];
    
    // チェック処理本体
    [self updateCanTapRecur:map start:pos];
}

-(void)updateCanTapRecur:(ObjectXDMap*)map start:(DLPoint)pos
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    if ([self->doneMap get_x:x y:y] != 0) return;
    
    BlockModel* b = [map get_x:x y:y];
    if (!b) return;
    
    [self->doneMap set_x:x y:y value:1];
    if (b.block_id != ID_EMPTY) {
        b.can_tap = YES;
    } else if (b.block_id == ID_EMPTY) {
        b.can_tap = NO;
        [self updateCanTapRecur:map start:cdp(x + 0, y + 1)];
        [self updateCanTapRecur:map start:cdp(x + 0, y - 1)];
        [self updateCanTapRecur:map start:cdp(x + 1, y + 0)];
        [self updateCanTapRecur:map start:cdp(x - 1, y + 0)];
        
        
        // スクロール用に 一番下の 空ブロックを記録しておく
        if (b.pos.y > self->lowestEmptyY) {
            self->lowestEmptyY = b.pos.y;
        }
        
        
    } else {
        // マイナスの時は？？
    }
}

@end
