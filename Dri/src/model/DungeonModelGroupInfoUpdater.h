//
//  DungeonModelGroupInfoUpdater.h
//  Dri
//
//  Created by okihara on 2013/02/10.
//
//

#import <Foundation/Foundation.h>
#import "DungeonModel.h"

@interface DungeonModelGroupInfoUpdater : NSObject
{
    XDMap *doneMap;
}

-(void)updateGroupInfo:(ObjectXDMap*)map start:(DLPoint)pos groupId:(unsigned int)groupId;
-(void)updateGroupInfoRecurs:(ObjectXDMap*)map start:(DLPoint)pos groupId:(unsigned int)groupId groupInfo:(NSMutableArray*)groupInfo;
@end
