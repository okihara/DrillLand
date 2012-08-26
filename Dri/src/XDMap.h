//
//  TileMap.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct DLPoint {
    int x;
    int y;
};
typedef struct DLPoint DLPoint;
DLPoint cdp(int x, int y);

#define CAP_W 20
#define CAP_H 100

@interface XDMap : NSObject
{
    int tile_map[CAP_H][CAP_W];
    int bound_w;
    int bound_h;
}

-(void)clear;
-(int)get:(DLPoint)pos;
-(int)get_x:(int)_x y:(int)_y;
-(void)set:(DLPoint)pos value:(int)_value;
-(void)set_x:(int)_x y:(int)_y value:(int)_value;
-(BOOL)is_outbound:(int)_x y:(int)y;
-(void)fill:(int)value;

@end

@interface ObjectXDMap : NSObject
{
    id tile_map[CAP_H][CAP_W];
    int bound_w;
    int bound_h;
}

-(void)clear;
-(id)get_x:(int)_x y:(int)_y;
-(void)set_x:(int)_x y:(int)_y value:(id)_value;
-(BOOL)is_outbound:(int)_x y:(int)y;
-(void)fill:(id)value;

@end