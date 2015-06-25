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
    [self.textField becomeFirstResponder];
}

- (NBEmojiSearchView *)emojiSearchView
{
    if (!_emojiSearchView) {
        _emojiSearchView = [[NBEmojiSearchView alloc] init];
        _emojiSearchView.frame = CGRectMake(0, 46.0, self.view.frame.size.width, self.view.frame.size.height - 46.0);
        [_emojiSearchView installOnTextField:self.textField];
        __weak typeof(self) weakSelf = self;
        // Appear animation customization
        _emojiSearchView.appearAnimationBlock = ^{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.emojiSearchView.alpha = 1.0;
            } completion:^(BOOL finished) {
                // Make sure you call appearAnimationDidFinish if you customize the appear animation!
                [weakSelf.emojiSearchView appearAnimationDidFinish];
            }];
        };
        // Disappear animation customization
        _emojiSearchView.disappearAnimationBlock = ^{
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.emojiSearchView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // Make sure you call disappearAnimationDidFinish if you customize the disappear animation!
                [weakSelf.emojiSearchView disappearAnimationDidFinish];
            }];
        };
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
