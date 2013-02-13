//
//  DungeonModelImpl.h
//  Dri
//
//  Created by okihara on 2013/02/10.
//
//

#import <Foundation/Foundation.h>
#import "DL.h"

#define INITIAL_LOWEST_EMPTY_Y 5

@class ObjectXDMap;
@class XDMap;

@interface DungeonModelCanTapUpdater : NSObject
{
    XDMap  *doneMap;
    UInt32 lowestEmptyY;
}
@property (nonatomic, readonly) UInt32 lowestEmptyY;

-(void)clearCanTap:(ObjectXDMap*)map;
-(void)updateCanTap:(ObjectXDMap*)map start:(DLPoint)pos;

@end
