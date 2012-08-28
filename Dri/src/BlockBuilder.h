//
//  BlockBuilder.h
//  Dri
//
//  Created by  on 12/08/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BlockModel.h"

@interface BlockBuilder : CCNode {
    NSMutableDictionary* builder_map;
}

-(void)setupBuilders;
-(void)setBuilderWithName:(NSString*)name builder:(SEL)builder_method;
-(BlockModel*)buildWithName:(NSString*)name;

@end
