#import "TSSpawnRootViewController.h"
#import <TSUtil.h>

@implementation TSSpawnRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TrollStore SpawnRoot";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // Initialize data structures
    self.processes = [NSMutableArray array];
    self.logOutput = [NSMutableString stringWithString:@"TrollStore SpawnRoot Initialized\n"];
    self.logOutput = [NSMutableString stringWithFormat:@"%@Executable: %@\n\n", self.logOutput, getExecutablePath()];
    
    [self setupUI];
    [self refreshProcessList];
}

- (void)setupUI {
    CGRect bounds = self.view.bounds;
    CGFloat padding = 10.0;
    CGFloat buttonHeight = 44.0;
    CGFloat segmentHeight = 32.0;
    
    // Mode segment control (Process List / Command Execution)
    self.modeSegment = [[UISegmentedControl alloc] initWithItems:@[@"Process List", @"Command Execution"]];
    self.modeSegment.selectedSegmentIndex = 0;
    self.modeSegment.frame = CGRectMake(padding, 100, bounds.size.width - 2*padding, segmentHeight);
    [self.modeSegment addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.modeSegment];
    
    // Table view for process list
    CGFloat tableY = CGRectGetMaxY(self.modeSegment.frame) + padding;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, bounds.size.width, bounds.size.height - tableY) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ProcessCell"];
    [self.view addSubview:self.tableView];
    
    // Command text field
    self.commandTextField = [[UITextField alloc] initWithFrame:CGRectMake(padding, tableY, bounds.size.width - 2*padding, buttonHeight)];
    self.commandTextField.placeholder = @"Enter command (e.g., /bin/ls)";
    self.commandTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.commandTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.commandTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.commandTextField.hidden = YES;
    [self.view addSubview:self.commandTextField];
    
    // Execute button
    CGFloat executeY = CGRectGetMaxY(self.commandTextField.frame) + padding;
    self.executeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.executeButton.frame = CGRectMake(padding, executeY, (bounds.size.width - 3*padding) / 2, buttonHeight);
    [self.executeButton setTitle:@"Execute as Root" forState:UIControlStateNormal];
    [self.executeButton addTarget:self action:@selector(executeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.executeButton.backgroundColor = [UIColor systemBlueColor];
    [self.executeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.executeButton.layer.cornerRadius = 8.0;
    self.executeButton.hidden = YES;
    [self.view addSubview:self.executeButton];
    
    // Clear button
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clearButton.frame = CGRectMake(CGRectGetMaxX(self.executeButton.frame) + padding, executeY, (bounds.size.width - 3*padding) / 2, buttonHeight);
    [self.clearButton setTitle:@"Clear Log" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.backgroundColor = [UIColor systemGrayColor];
    [self.clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clearButton.layer.cornerRadius = 8.0;
    self.clearButton.hidden = YES;
    [self.view addSubview:self.clearButton];
    
    // Log text view
    CGFloat logY = CGRectGetMaxY(self.executeButton.frame) + padding;
    self.logTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, logY, bounds.size.width - 2*padding, bounds.size.height - logY - padding)];
    self.logTextView.editable = NO;
    self.logTextView.font = [UIFont fontWithName:@"Menlo" size:12.0];
    self.logTextView.layer.borderColor = [UIColor systemGrayColor].CGColor;
    self.logTextView.layer.borderWidth = 1.0;
    self.logTextView.layer.cornerRadius = 8.0;
    self.logTextView.text = self.logOutput;
    self.logTextView.hidden = YES;
    [self.view addSubview:self.logTextView];
}

- (void)modeChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        // Process List mode
        self.tableView.hidden = NO;
        self.commandTextField.hidden = YES;
        self.executeButton.hidden = YES;
        self.clearButton.hidden = YES;
        self.logTextView.hidden = YES;
        [self refreshProcessList];
    } else {
        // Command Execution mode
        self.tableView.hidden = YES;
        self.commandTextField.hidden = NO;
        self.executeButton.hidden = NO;
        self.clearButton.hidden = NO;
        self.logTextView.hidden = NO;
    }
}

- (void)executeButtonTapped:(UIButton *)sender {
    NSString *command = self.commandTextField.text;
    if (!command || command.length == 0) {
        [self appendLog:@"Error: No command specified\n"];
        return;
    }
    
    // Parse command and args
    NSArray *components = [command componentsSeparatedByString:@" "];
    NSString *commandPath = components.firstObject;
    NSArray *args = components.count > 1 ? [components subarrayWithRange:NSMakeRange(1, components.count - 1)] : @[];
    
    [self executeRootCommand:commandPath withArgs:args];
}

- (void)clearButtonTapped:(UIButton *)sender {
    self.logOutput = [NSMutableString stringWithString:@"Log cleared\n"];
    self.logTextView.text = self.logOutput;
}

- (void)executeRootCommand:(NSString *)command withArgs:(NSArray *)args {
    [self appendLog:[NSString stringWithFormat:@"Executing: %@ %@\n", command, [args componentsJoinedByString:@" "]]];
    
    NSString *stdOut = nil;
    NSString *stdErr = nil;
    
    // Use spawnRoot from TSUtil to execute command with root privileges
    int result = spawnRoot(command, args, &stdOut, &stdErr);
    
    [self appendLog:[NSString stringWithFormat:@"Exit code: %d\n", result]];
    
    if (stdOut && stdOut.length > 0) {
        [self appendLog:@"--- STDOUT ---\n"];
        [self appendLog:stdOut];
        [self appendLog:@"\n"];
    }
    
    if (stdErr && stdErr.length > 0) {
        [self appendLog:@"--- STDERR ---\n"];
        [self appendLog:stdErr];
        [self appendLog:@"\n"];
    }
    
    [self appendLog:@"---\n\n"];
}

- (void)refreshProcessList {
    [self.processes removeAllObjects];
    
    // Use enumerateProcessesUsingBlock from TSUtil to list running processes
    enumerateProcessesUsingBlock(^(pid_t pid, NSString *executablePath, BOOL *stop) {
        NSDictionary *processInfo = @{
            @"pid": @(pid),
            @"path": executablePath ?: @"(unknown)"
        };
        [self.processes addObject:processInfo];
    });
    
    [self.tableView reloadData];
}

- (void)appendLog:(NSString *)text {
    [self.logOutput appendString:text];
    self.logTextView.text = self.logOutput;
    
    // Scroll to bottom
    NSRange range = NSMakeRange(self.logOutput.length - 1, 1);
    [self.logTextView scrollRangeToVisible:range];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.processes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessCell" forIndexPath:indexPath];
    
    NSDictionary *process = self.processes[indexPath.row];
    NSNumber *pid = process[@"pid"];
    NSString *path = process[@"path"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"[%@] %@", pid, path.lastPathComponent];
    cell.detailTextLabel.text = path;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *process = self.processes[indexPath.row];
    NSNumber *pid = process[@"pid"];
    NSString *path = process[@"path"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Process Details"
                                                                   message:[NSString stringWithFormat:@"PID: %@\nPath: %@", pid, path]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

@end
