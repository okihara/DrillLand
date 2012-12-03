//
//  DungeonLoader.m
//  Dri
//
//  Created by  on 12/10/26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DungeonLoader.h"
#import "SBJson.h"
#import "DungeonModel.h"
#import "BlockBuilder.h"

@implementation DungeonLoader

-(id)initWithDungeonModel:(DungeonModel*)dungeon_model_
{
    if (self = [super init]) {
        self->dungeon_model = dungeon_model_;
        self->block_builder = [[BlockBuilder alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self->block_builder release];
    [super dealloc];
}

//---------------------------------------------------
// フロア情報をロード
-(void)load_from_file:(NSString*)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    NSArray* layers = [(NSDictionary*)jsonItem objectForKey:@"layers"];
    NSArray* data = [[layers objectAtIndex:0] objectForKey:@"data"];
    
    NSArray *tilesets = [(NSDictionary*)jsonItem objectForKey:@"tilesets"];
    NSDictionary* tileset = [tilesets objectAtIndex:0];
    NSDictionary* tileproperties = [tileset objectForKey:@"tileproperties"];
    
    int width  = [[jsonItem objectForKey:@"width"] integerValue];
    //int height = [[jsonItem objectForKey:@"height"] integerValue];
    
    for (int j = 0; j < DM_HEIGHT; j++) {
        for (int i = 0; i < width; i++) {
            
            BlockModel* b;
            int b_ind = [[data objectAtIndex:i + j * width] integerValue];
            if (b_ind == 0 || b_ind == 1) {
                b = [self->block_builder buildWithID:ID_NORMAL_BLOCK];
                b.block_id = ID_EMPTY;
            } else {
                NSDictionary* prop = [tileproperties objectForKey:[NSString stringWithFormat:@"%d", b_ind-1]];
                int type_id = [[prop objectForKey:@"block_id"] intValue];
                b = [block_builder buildWithID:type_id];
            }
            
            [self->dungeon_model set_without_update_can_tap:cdp(i, j) block:b];
        }
    }
}

@end
