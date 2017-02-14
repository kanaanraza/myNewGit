//
//  TryCatch.m
//  EOBD2
//
//  Created by Rockville Developer on 5/26/15.
//  Copyright (c) 2015 Macbook Pro. All rights reserved.
//

#import "TryCatchHandling.h"

@implementation TryCatchHandling

+ (void)try:(void(^)())try catch:(void(^)(NSException *exception))catch finally:(void(^)())finally {
    
    @try {
        
        try ? try() : nil;
    }
    @catch (NSException *exception) {
        
        catch ? catch(exception) : nil;
    }
    @finally {
        
        finally ? finally() : nil;
    }
}
@end

