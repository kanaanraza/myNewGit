//
//  TryCatch.h
//  EOBD2
//
//  Created by Rockville Developer on 5/26/15.
//  Copyright (c) 2015 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TryCatchHandling : NSObject

+ (void)try:(void(^)())try catch:(void(^)(NSException *exception))catch finally:(void(^)())finally;

@end
