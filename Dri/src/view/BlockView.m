//
//  BlockView.m
//  Dri
//
//  Created by  on 12/08/18.
//  Copyright 2012 Hiromitsu. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"
#import "DungeonView.h"


@interface BlockView()
- (CCAction *)_updatePresentation:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e;
@end

@implementation BlockView

@synthesize is_alive;
@synthesize is_change; // TODO: カプセル化違反
@synthesize pos;

- (void)setup
{
    is_alive    = YES;
    is_change   = NO;
    is_touching = NO;

    self->events            = [[NSMutableArray array] retain];
    self->presentation_list = [[NSMutableArray array] retain];
}

- (void)dealloc
{
    [self->presentation_list release];
    [self->events release];
    [super dealloc];
}


//------------------------------------------------------------------------------
// Event

- (CCAction*)handleEvent:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
{
    return [self _updatePresentation:ctx event:e];
}


//------------------------------------------------------------------------------
// Presentation

- (void)addPresentation:(NSObject<BlockPresentation> *)presentation
{
    [self->presentation_list addObject:presentation];
}


- (CCAction*)_updatePresentation:(NSObject<ViewContextProtocol>*)ctx event:(DLEvent*)e
{
    NSMutableArray *actions = [NSMutableArray array];
    
    for (NSObject<BlockPresentation>* p in self->presentation_list) {
        CCAction *action = [p handle_event:ctx event:e view:self];
        if (action) {
            [actions addObject:action];
        }
    }
    
    return [actions count] ? [CCSequence actionWithArray:actions] : nil;
}

- (CCFiniteTimeAction *)playAnime:(BlockModel*)blockModel name:(NSString *)suffix
{
    NSString *animeName = [NSString stringWithFormat:@"%d%@", blockModel.block_id, suffix];
    return [self play:animeName];
}

@end
