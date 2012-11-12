//
//  MasterLoader.m
//  Dri
//
//  Created by  on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterLoader.h"
#import "SBJson.h"

@implementation MasterLoader

NSArray *master_list;

-(void)load:(NSString*)filename
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
    NSString *jsonData = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    id jsonItem = [jsonData JSONValue];
    master_list = [(NSDictionary*)jsonItem objectForKey:@"block_master"];
    
    NSLog(@"master_list %@", master_list);
}

+(NSDictionary*)get_master_by_id:(uint)id_
{
    for (NSDictionary *json in master_list) {
        NSNumber *number = [json objectForKey:@"type"];
        uint block_id = [number unsignedIntValue];
        if (block_id == id_) {
            return json;
        }
    }
    return nil;
}

@end
