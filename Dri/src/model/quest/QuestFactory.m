//
//  QuestFactory.m
//  Dri
//
//  Created by  on 12/10/03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestFactory.h"
#import "Quest.h"
#import "QuestCondition.h"
#import "PickCondition.h"

@implementation QuestFactory

-(Quest*)make_test
{
    QuestCondition *pick_cond = [QuestCondition new];
    Quest *quest = [[Quest alloc] initWithQuestId:0 conditions:[NSArray arrayWithObjects:pick_cond, nil]];
    return quest;
}

@end
