//
//  CSCConfigLoader.m
//  Pods
//
//  Created by Ryan Meador on 4/16/15.
//
//

#import "CSCConfigLoader.h"

@interface CSCConfigLoader()
    @property NSDictionary *config;
    @property CSCConfigLoader *fallback;
@end

@implementation CSCConfigLoader

static CSCConfigLoader *_main;
static NSMutableDictionary *_bundleConfigs;

+ (instancetype) mainConfig
{
    if (!_main) {
        _main = [self configFromBundle:[NSBundle mainBundle]];
    }
    
    return _main;
}

+ (instancetype) mainConfigWithFallbackFrom:(NSBundle *)bundle
{
    // because this is just two pointers, once these configs have been loaded once each,
    // this is a very lightweight process
    CSCConfigLoader *new = [[CSCConfigLoader alloc] initWithConfig:[self mainConfig]];
    [new fallBackToConfig:[self configFromBundle:bundle]];
    return new;
}

+ (instancetype) configFromBundle:(NSBundle *)bundle
{
    if (!_bundleConfigs) {
        _bundleConfigs = [NSMutableDictionary new];
    }
    
    if (!_bundleConfigs[bundle.bundlePath]) {
        NSString *path = [bundle pathForResource:@"config" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        _bundleConfigs[bundle.bundlePath] = [[CSCConfigLoader alloc] initWithDictionary:dict];
    }
    
    return _bundleConfigs[bundle.bundlePath];
}

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.config = dict;
    }
    
    return self;
}

- (instancetype) initWithConfig:(CSCConfigLoader *)config
{
    self = [super init];
    if (self) {
        self.config = config.config;
    }
    
    return self;
}

- (void) fallBackToConfig:(CSCConfigLoader *)config
{
    self.fallback = config;
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    if (self.config[key]) {
        return self.config[key];
    }
    
    if (self.fallback) {
        return self.fallback[key];
    }
    
    return nil;
}

@end
