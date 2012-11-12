//
//  MasterLoader.h
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterLoader : NSObject

-(void)load:(NSString*)filename;
+(NSDictionary*)get_master_by_id:(uint)id_;

@end
