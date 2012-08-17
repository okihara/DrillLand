//
//  DungeonView.h
//  Dri
//
//  Created by  on 12/08/17.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DungeonModel.h"

@interface DungeonView : CCLayer<DungenModelObserver>
{
    id  delegate;
    int offset_y;
    int disp_w;
    int disp_h;
}

@property (nonatomic, retain) id delegate;

@end
