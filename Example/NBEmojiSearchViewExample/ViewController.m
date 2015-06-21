#import "NBEmojiSearchView.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NBEmojiSearchView *emojiSearchView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.emojiSearchView];
    [self registerForKeyboardNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.textField becomeFirstResponder];
}

- (NBEmojiSearchView *)emojiSearchView
{
    if (!_emojiSearchView) {
        _emojiSearchView = [[NBEmojiSearchView alloc] init];
        _emojiSearchView.frame = CGRectMake(0, 46.0, self.view.frame.size.width, self.view.frame.size.height - 46.0);
        [_emojiSearchView installOnTextField:self.textField];
    }
    return _emojiSearchView;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIKeyboardWillChangeFrameNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * __nonnull note) {
         CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         self.emojiSearchView.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.size.height, 0.0);
     }];
}

@end
