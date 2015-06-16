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
    [self.emojiSearchView installOnTextField:self.textField delegate:self];
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
        _emojiSearchView.frame = CGRectMake(0, 46, self.view.frame.size.width, 405);
    }
    return _emojiSearchView;
}

@end
