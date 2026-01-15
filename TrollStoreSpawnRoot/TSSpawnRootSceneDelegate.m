#import "TSSpawnRootSceneDelegate.h"
#import "TSSpawnRootViewController.h"

@implementation TSSpawnRootSceneDelegate

/**
 * scene:willConnectToSession:options:
 *
 * Called when a scene is about to connect to a session.
 * This is where we set up the window and root view controller for scene-based apps.
 */
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        // Create window for this scene
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        // Create root view controller
        TSSpawnRootViewController *rootViewController = [[TSSpawnRootViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        
        // Set root view controller
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
        
        NSLog(@"TrollStore SpawnRoot: Scene connected");
    }
}

/**
 * sceneDidDisconnect:
 *
 * Called when a scene is disconnected.
 */
- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"TrollStore SpawnRoot: Scene disconnected");
}

/**
 * sceneDidBecomeActive:
 *
 * Called when the scene becomes active.
 */
- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"TrollStore SpawnRoot: Scene became active");
}

/**
 * sceneWillResignActive:
 *
 * Called when the scene is about to resign active status.
 */
- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"TrollStore SpawnRoot: Scene will resign active");
}

/**
 * sceneWillEnterForeground:
 *
 * Called when the scene is about to enter the foreground.
 */
- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"TrollStore SpawnRoot: Scene will enter foreground");
}

/**
 * sceneDidEnterBackground:
 *
 * Called when the scene enters the background.
 */
- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"TrollStore SpawnRoot: Scene entered background");
}

@end
