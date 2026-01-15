#import <UIKit/UIKit.h>

/**
 * TSSpawnRootAppDelegate
 *
 * Application delegate for TrollStore SpawnRoot (legacy, non-scene based).
 * Used on iOS versions that don't support scenes or when scene configuration is not available.
 */
@interface TSSpawnRootAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@end
