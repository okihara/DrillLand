//
//  DungeonModelUpdateRouteMap.m
//  Dri
//
//  Created by okihara on 2013/02/11.
//
//

#import "DungeonModelRouteMap.h"

@implementation DungeonModelRouteMap

@synthesize route_list;

- (id)init
{
    if (self = [super init]) {
        self->route_map = [[XDMap alloc] init];
        self->route_list = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->route_list release];
    [self->route_map release];
    [super dealloc];
}

-(void) update:(ObjectXDMap*)map start:(DLPoint)pos target:(DLPoint)target
{
    [self->route_map fill:999];
    [self update_route_map_r:map start:pos target:target level:0];
}

-(void) update_route_map_r:(ObjectXDMap*)map start:(DLPoint)pos target:(DLPoint)target level:(int)level
{
    // ゴール以降は探索しない
    //    if (pos.x == target.x && pos.y == target.y) {
    //        [self->route_map set_x:pos.x y:pos.y value:level];
    //        return;
    //    }
    
    // ブロックの場合はそれ以上探索しない
    // ただし level = 0 （最初の一回目は）例外
    BlockModel* b = [map get_x:pos.x y:pos.y];
    if (b.block_id != ID_EMPTY && level != 0) return;
    
    int cost = [self->route_map get_x:pos.x y:pos.y];
    
    // 画面外は -1 が返る
    // 画面外なら、それ以上探索しない
    if (cost < 0) return;
    
    // 計算済みの cost が同じか小さい場合探索しない
    if (cost <= level) return;
    
    [self->route_map set_x:pos.x y:pos.y value:level];
    
    [self update_route_map_r:map start:cdp(pos.x + 0, pos.y - 1) target:target level: level + 1];
    [self update_route_map_r:map start:cdp(pos.x + 0, pos.y + 1) target:target level: level + 1];
    [self update_route_map_r:map start:cdp(pos.x - 1, pos.y + 0) target:target level: level + 1];
    [self update_route_map_r:map start:cdp(pos.x + 1, pos.y + 0) target:target level: level + 1];
}

-(DLPoint)get_player_pos:(DLPoint)pos
{
    [self->route_list removeAllObjects];
    return [self _get_player_pos:pos];
}

-(DLPoint)_get_player_pos:(DLPoint)pos
{
    //# ゴールなので座標を返す
    int cost = [self->route_map get:pos];
    if (cost == 1) return pos;
    // 移動なし
    // TODO: マジックナンバー(>_<)
    if (cost == 999) return pos;
    
    DLPoint u_pos = cdp(pos.x + 0, pos.y - 1);
    DLPoint d_pos = cdp(pos.x + 0, pos.y + 1);
    DLPoint l_pos = cdp(pos.x - 1, pos.y + 0);
    DLPoint r_pos = cdp(pos.x + 1, pos.y + 0);
    int u_cost = [self->route_map get:u_pos];
    int d_cost = [self->route_map get:d_pos];
    int l_cost = [self->route_map get:l_pos];
    int r_cost = [self->route_map get:r_pos];
    u_cost = u_cost < 0 ? 999 : u_cost;
    d_cost = d_cost < 0 ? 999 : d_cost;
    l_cost = l_cost < 0 ? 999 : l_cost;
    r_cost = r_cost < 0 ? 999 : r_cost;
    
    NSArray *cost_list = [NSArray arrayWithObjects:
                          [NSNumber numberWithInt:l_cost],
                          [NSNumber numberWithInt:r_cost],
                          [NSNumber numberWithInt:d_cost],
                          [NSNumber numberWithInt:u_cost],
                          nil];
    
    int min_cost = l_cost;
    int index = 0;
    for (int i = 1; i < 4; i++) {
        int cost = [[cost_list objectAtIndex:i] intValue];
        if (cost < min_cost) {
            min_cost = cost;
            index = i;
        }
    }
    
    DLPoint out_pos;
    switch (index) {
        case 0:
            out_pos = l_pos;
            break;
        case 1:
            out_pos = r_pos;
            break;
        case 2:
            out_pos = d_pos;
            break;
        case 3:
            out_pos = u_pos;
            break;
        default:
            break;
    }
    
    [self->route_list addObject:[NSValue valueWithBytes:&out_pos objCType:@encode(DLPoint)]];
    
    return [self _get_player_pos:out_pos];
}


@end
