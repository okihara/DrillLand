//
//  HuntingCondition.h
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestCondition.h"

@interface HuntingCondition : QuestCondition
{
    uint target_block_id;
    uint required_num;
}

@end
