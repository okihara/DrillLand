//
//  DungeonLoader.h
//  Dri
//
//  Created by  on 12/10/26.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DungeonModel;
@class BlockBuilder;

@interface DungeonLoader : NSObject
{
    DungeonModel *dungeon_model;
    BlockBuilder *block_builder;
}

-(id)initWithDungeonModel:(DungeonModel*)dungeon_model_;
-(void)load_from_file:(NSString*)filename;

@end
