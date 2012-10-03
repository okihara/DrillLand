//
//  PickCondition.h
//  Dri
//
//  Created by  on 12/10/02.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestCondition.h"

@interface PickCondition : QuestCondition
{
    uint block_id;
    uint num_required;
    
    uint counter;
}

@end
