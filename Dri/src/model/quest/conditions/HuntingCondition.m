//
//  HuntingCondition.m
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HuntingCondition.h"

@implementation HuntingCondition

-(id)initWithTargetId:(enum ID_BLOCK)target_id required_num:(uint)req_num
{
    if(self = [super init]) {
        self->target_block_id = target_id;
        self->required_num = req_num;
        self->counter = 0;
    }
    return self;
}

- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)event
{
    BlockModel *block = event.target;
    
    switch (event.type) {
            
        case DL_ON_DESTROY:
            
            if (block.block_id == self->target_block_id) {
                self->counter++;
                if (counter == required_num) {
                    DLEvent *e = [DLEvent eventWithType:DL_ON_CLEAR target:nil];
                    [dungeon_ dispatchEvent:e];
                }
            }
            break;
            
        default:
            break;
    } 
}

-(BOOL)judge:(void*)environment
{
    NSLog(@"[EVENT] ----- kiteru");
    return NO;
}

@end
