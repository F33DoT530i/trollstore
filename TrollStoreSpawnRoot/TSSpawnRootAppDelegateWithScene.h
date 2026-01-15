#import <UIKit/UIKit.h>

/**
 * TSSpawnRootAppDelegateWithScene
 *
 * Application delegate for TrollStore SpawnRoot with scene support.
 * Used on iOS 13+ when UIScene configuration is available.
 */
@interface TSSpawnRootAppDelegateWithScene : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@end
