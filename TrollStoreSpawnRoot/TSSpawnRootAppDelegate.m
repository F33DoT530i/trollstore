#import "TSSpawnRootAppDelegate.h"
#import "TSSpawnRootViewController.h"

@implementation TSSpawnRootAppDelegate

/**
 * application:didFinishLaunchingWithOptions:
 *
 * Called when the application finishes launching.
 * Sets up the window and root view controller for legacy (non-scene) mode.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create main window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // Create root view controller
    TSSpawnRootViewController *rootViewController = [[TSSpawnRootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // Set root view controller
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    NSLog(@"TrollStore SpawnRoot: Application launched (non-scene mode)");
    
    return YES;
}

@end
