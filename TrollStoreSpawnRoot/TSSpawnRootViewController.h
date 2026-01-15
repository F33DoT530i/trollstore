#import <UIKit/UIKit.h>

/**
 * TSSpawnRootViewController
 *
 * Main view controller for TrollStore SpawnRoot application.
 * Provides interface for:
 * - Spawning root processes
 * - Enumerating running processes
 * - Managing process lifecycle
 * - Testing root spawn capabilities
 */
@interface TSSpawnRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// UI Elements
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UITextField *commandTextField;
@property (nonatomic, strong) UIButton *executeButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UISegmentedControl *modeSegment;

// Data
@property (nonatomic, strong) NSMutableArray *processes;
@property (nonatomic, strong) NSMutableString *logOutput;

/**
 * Executes a command as root using spawnRoot from TSUtil
 * @param command The command path to execute
 * @param args Arguments array for the command
 */
- (void)executeRootCommand:(NSString *)command withArgs:(NSArray *)args;

/**
 * Refreshes the list of running processes
 */
- (void)refreshProcessList;

/**
 * Appends text to the log output
 * @param text The text to append
 */
- (void)appendLog:(NSString *)text;

@end
