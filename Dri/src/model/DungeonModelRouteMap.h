//
//  DungeonModelUpdateRouteMap.h
//  Dri
//
//  Created by okihara on 2013/02/11.
//
//

#import <Foundation/Foundation.h>
#import "DungeonModel.h"

@interface DungeonModelRouteMap : NSObject
{
    XDMap *route_map;
    NSMutableArray *route_list;
}
@property (nonatomic, readonly) NSMutableArray *route_list;

-(void)update:(ObjectXDMap*)map start:(DLPoint)pos target:(DLPoint)target;
-(DLPoint)get_player_pos:(DLPoint)pos;

@end
