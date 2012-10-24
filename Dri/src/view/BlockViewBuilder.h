//
//  BlockViewBuilder.h
//  Dri
//
//  Created by  on 12/09/17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlockView;
@class BlockModel;
@class DungeonModel;


@interface BlockViewBuilder : NSObject
{
}

+(BlockView *)build:(BlockModel*)block_model ctx:(DungeonModel*)dungeon_model;

@end

