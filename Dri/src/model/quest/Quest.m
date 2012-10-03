//
//  Quest.m
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Quest.h"
#import "QuestCondition.h"

@implementation Quest

-(id)initWithQuestId:(uint)quest_id_ conditions:(NSArray*)conditions
{
    if(self = [super init]) {
        self->quest_id = quest_id_;
        self->condition_list = [conditions retain];
    }
    return self;
}

- (void)notify:(DungeonModel*)dungeon_ event:(DLEvent*)e;
{
    for (QuestCondition *quest_cond in self->condition_list) {
        [quest_cond notify:dungeon_ event:e];
    }
}

-(void)judge:(void*)environment
{
    for (QuestCondition *quest_cond in self->condition_list) {
        [quest_cond judge:environment];
    }
}

@end
