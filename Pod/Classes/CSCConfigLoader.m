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
    
    NSString *bundleKey = bundle.bundleIdentifier ? bundle.bundleIdentifier : bundle.bundlePath;
    
    if (!_bundleConfigs[bundleKey]) {
        NSString *path = [bundle pathForResource:@"config" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        if (!dict) {
            NSLog(@"CSCConfigLoader: couldn't load config for bundle %@", bundleKey);
        } else {
            NSLog(@"CSCConfigLoader: loaded config for bundle %@", bundleKey);
        }
        
        _bundleConfigs[bundleKey] = [[CSCConfigLoader alloc] initWithDictionary:dict];
    }
    
    return _bundleConfigs[bundleKey];
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
    if (!self.config) { // if there's no main config, the fallback _is_ the config
        self.config = config.config;
    } else {
        self.fallback = config;
    }
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key
{
    if (!self.config) { // the bundle may not actually have a config file
        return nil;
    }
    
    if (self.config[key]) {
        return self.config[key];
    }
    
    if (self.fallback) {
        return self.fallback[key];
    }
    
    return nil;
}

@end
