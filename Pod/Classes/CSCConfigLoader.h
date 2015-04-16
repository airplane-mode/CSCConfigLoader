//
//  CSCConfigLoader.h
//  Pods
//
//  Created by Ryan Meador on 4/16/15.
//
//

#import <Foundation/Foundation.h>

@interface CSCConfigLoader : NSObject

+ (instancetype) mainConfig;

+ (instancetype) mainConfigWithFallbackFrom:(NSBundle *)bundle;

+ (instancetype) configFromBundle:(NSBundle *)bundle;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;

@end
