//
//  VE_DownloadManager.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#warning Blocks Singleton GCD ImageCache

#import "VE_DownloadManager.h"

#define MAX_NETWORK_DOWNLOADS 4

@interface DownloadTask : NSObject
@property (strong) NSURL *dataUrl;
@property (copy) DownloadComplitionBlock complitionBlock;
@end

@implementation DownloadTask
@end

#pragma mark -

@interface VE_DownloadManager ()
{
    dispatch_queue_t _downloadQueue;
    dispatch_queue_t _cacheQueue;
    __strong NSMutableDictionary *_cache;
}
@end

@implementation VE_DownloadManager

- (id)_init
{
    self = [super init];
    if (self)
    {
        _downloadQueue = dispatch_queue_create("ve.presentation.download_queue", DISPATCH_QUEUE_SERIAL);
        _cacheQueue = dispatch_queue_create("ve.presentation.cache_queue", DISPATCH_QUEUE_SERIAL);
        _cache = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}

+ (id)sharedInstance
{
	static VE_DownloadManager *_sharedInstance;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance)
            _sharedInstance = [[VE_DownloadManager alloc] _init];
    });
    
    return _sharedInstance;
}

- (void)clearCache
{
    dispatch_sync(_cacheQueue, ^{
        [_cache removeAllObjects];
    });
}

- (void)setCacheObject:(id)obj forKey:(id<NSCopying>)key
{
    dispatch_sync(_cacheQueue, ^{
        [_cache setObject:obj forKey:key];
    });
}

- (id)cachedObjectForKey:(id<NSCopying>)key
{
    __block id obj;
    dispatch_sync(_cacheQueue, ^{
        obj = [_cache objectForKey:key];
    });
    return obj;
}

- (void)downloadDataWithURLString:(NSString *)dataUrlString
                       usingCache:(BOOL)usingCache
               andComplitionBlock:(DownloadComplitionBlock)block
{
    dispatch_async(_downloadQueue, ^
                   {
                       NSData *data;
                       if (usingCache)
                       {
                           id cachedObj = [self cachedObjectForKey:dataUrlString];
                           if ([cachedObj isKindOfClass:[NSData class]])
                           {
                               data = (NSData *)cachedObj;
                           }
                       }
                       if (!data)
                       {
                           data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dataUrlString]];
                       }
                       if (usingCache)
                       {
                           [self setCacheObject:data forKey:dataUrlString];
                       }
                       if (block)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              block(data);
                                          });
                       }
                   });
}

@end
