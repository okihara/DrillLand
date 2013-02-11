//
//  DungeonModelGroupInfoUpdater.m
//  Dri
//
//  Created by okihara on 2013/02/10.
//
//

#import "DungeonModelGroupInfoUpdater.h"

@implementation DungeonModelGroupInfoUpdater

- (id)init
{
    if (self = [super init]) {
        self->doneMap = [[XDMap alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->doneMap release];
    [super dealloc];
}

-(void)updateGroupInfo:(ObjectXDMap*)map
                 start:(DLPoint)pos
               groupId:(unsigned int)groupId
{
    if (groupId == 0) return; // groupId 0 はグループ化しない
    
    [self->doneMap clear];
    NSMutableArray* groupInfo = [[NSMutableArray alloc] init];
    [self updateGroupInfoRecurs:map start:pos groupId:groupId groupInfo:groupInfo];
}

-(void)updateGroupInfoRecurs:(ObjectXDMap*)map
                       start:(DLPoint)pos
                     groupId:(unsigned int)groupId
                   groupInfo:(NSMutableArray*)groupInfo
{
    int x = (int)pos.x;
    int y = (int)pos.y;
    
    // もうみた
    if ([self->doneMap get_x:x y:y] != 0) return;
    
    // おかしい
    BlockModel* b = [map get_x:x y:y];
    if (b == NULL) return;
    
    // みたよ
    [self->doneMap set_x:x y:y value:1];
    
    // 同じじゃないならなにもしない
    if (b.group_id != groupId) return;
    
    // TODO:メモリリーク
    if (b.group_info != NULL) {
        //[b.group_info release];
    }
    [groupInfo addObject:b];
    b.group_info = groupInfo;
    
    [self updateGroupInfoRecurs:map start:cdp(x + 0, y + 1) groupId:groupId groupInfo:groupInfo];
    [self updateGroupInfoRecurs:map start:cdp(x + 0, y - 1) groupId:groupId groupInfo:groupInfo];
    [self updateGroupInfoRecurs:map start:cdp(x + 1, y + 0) groupId:groupId groupInfo:groupInfo];
    [self updateGroupInfoRecurs:map start:cdp(x - 1, y + 0) groupId:groupId groupInfo:groupInfo];
}

@end
