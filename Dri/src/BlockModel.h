//
//  BlockBase.h
//  Dri
//
//  Created by  on 12/08/16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockModel : NSObject
{
    int hp;
    int type;
    unsigned int group_id;
    id group_info;
    BOOL can_tap;
    NSMutableArray* behavior_list;
}

-(void)on_hit;

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) unsigned int group_id;
@property (nonatomic, assign) NSMutableArray* group_info;
@property (nonatomic, assign) BOOL can_tap;
@property (nonatomic, assign) unsigned int x;
@property (nonatomic, assign) unsigned int y;

@end