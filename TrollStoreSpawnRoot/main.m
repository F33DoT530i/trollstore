#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSSpawnRootAppDelegate.h"
#import "TSSpawnRootAppDelegateWithScene.h"
#import "TSSpawnRootSceneDelegate.h"
#import <TSUtil.h>
#import <objc/runtime.h>

/**
 * sceneDelegateFix
 * 
 * Dynamically fixes scene delegate configuration by parsing the Info.plist
 * and creating a subclass of TSSpawnRootSceneDelegate with the appropriate name.
 * This ensures compatibility with apps that use scene-based UI management (iOS 13+).
 *
 * @return YES if scene delegate was successfully configured, NO otherwise
 */
BOOL sceneDelegateFix(void)
{
	NSString* sceneDelegateClassName = nil;
	
	// Parse UIApplicationSceneManifest from Info.plist to find scene delegate class name
	NSDictionary* UIApplicationSceneManifest = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIApplicationSceneManifest"];
	if(UIApplicationSceneManifest && [UIApplicationSceneManifest isKindOfClass:NSDictionary.class])
	{
		NSDictionary* UISceneConfiguration = UIApplicationSceneManifest[@"UISceneConfigurations"];
		if(UISceneConfiguration && [UISceneConfiguration isKindOfClass:NSDictionary.class])
		{
			NSArray* UIWindowSceneSessionRoleApplication = UISceneConfiguration[@"UIWindowSceneSessionRoleApplication"];
			if(UIWindowSceneSessionRoleApplication && [UIWindowSceneSessionRoleApplication isKindOfClass:NSArray.class])
			{
				NSDictionary* sceneToUse = nil;
				
				// If multiple scenes exist, prefer "Default Configuration"
				if(UIWindowSceneSessionRoleApplication.count > 1)
				{
					for(NSDictionary* scene in UIWindowSceneSessionRoleApplication)
					{
						if([scene isKindOfClass:NSDictionary.class])
						{
							NSString* UISceneConfigurationName = scene[@"UISceneConfigurationName"];
							if([UISceneConfigurationName isKindOfClass:NSString.class])
							{
								if([UISceneConfigurationName isEqualToString:@"Default Configuration"])
								{
									sceneToUse = scene;
									break;
								}
							}
						}
					}

					if(!sceneToUse)
					{
						sceneToUse = UIWindowSceneSessionRoleApplication.firstObject;
					}
				}
				else
				{
					sceneToUse = UIWindowSceneSessionRoleApplication.firstObject;
				}

				if(sceneToUse && [sceneToUse isKindOfClass:NSDictionary.class])
				{
					sceneDelegateClassName = sceneToUse[@"UISceneDelegateClassName"];
				}
			}
		}
	}

	// Dynamically create scene delegate subclass if needed
	if(sceneDelegateClassName && [sceneDelegateClassName isKindOfClass:NSString.class])
	{
		Class newClass = objc_allocateClassPair([TSSpawnRootSceneDelegate class], sceneDelegateClassName.UTF8String, 0);
		objc_registerClassPair(newClass);
		return YES;
	}

	return NO;
}

/**
 * main
 *
 * Entry point for the TrollStore SpawnRoot application.
 * This application provides functionality for spawning root processes,
 * managing entitlements, and includes utilities for WiFi/cellular fixes.
 *
 * Features:
 * - Root process spawning via spawnRoot() from TSUtil
 * - Process enumeration and management
 * - WiFi/Cellular policy fixes (chineseWifiFixup)
 * - Compatible with both scene-based and traditional app delegates
 * - iOS 14.0+ compatibility
 *
 * @param argc Number of command line arguments
 * @param argv Array of command line argument strings
 * @param envp Array of environment variables
 * @return Exit status code
 */
int main(int argc, char *argv[], char *envp[]) {
	@autoreleasepool {
		// Apply Chinese WiFi fixup to ensure proper network connectivity
		// This sets cellular and WiFi usage policies to "AlwaysAllow"
		chineseWifiFixup();
		
		// Determine which app delegate to use based on scene support
		if(sceneDelegateFix())
		{
			// iOS 13+ with scene support
			return UIApplicationMain(argc, argv, nil, NSStringFromClass(TSSpawnRootAppDelegateWithScene.class));
		}
		else
		{
			// Legacy iOS or apps without scene support
			return UIApplicationMain(argc, argv, nil, NSStringFromClass(TSSpawnRootAppDelegate.class));
		}
	}
}
