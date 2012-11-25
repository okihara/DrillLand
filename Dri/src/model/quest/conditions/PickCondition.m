//
//  PickCondition.m
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickCondition.h"

@implementation PickCondition

-(id)init
{
    if(self = [super init]) {
        self->block_id = ID_ITEM_BLOCK_0;
        self->num_required = 3;
        self->counter = 0;
    }
    return self;
}
- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)event
{
    BlockModel *block = event.target;
    
    switch (event.type) {
            
        case DL_ON_GET:
            
            if (block.block_id == ID_ITEM_BLOCK_1) {
                self->counter++;
                if (counter == num_required) {
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
