#import "TSSpawnRootAppDelegateWithScene.h"

@implementation TSSpawnRootAppDelegateWithScene

/**
 * application:didFinishLaunchingWithOptions:
 *
 * Called when the application finishes launching.
 * For scene-based apps, the actual UI setup happens in the scene delegate.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"TrollStore SpawnRoot: Application launched (scene mode)");
    return YES;
}

/**
 * application:configurationForConnectingSceneSession:options:
 *
 * Returns the configuration for new scene sessions.
 */
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

/**
 * application:didDiscardSceneSessions:
 *
 * Called when the user discards a scene session.
 */
- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Handle scene session discard if needed
}

@end
