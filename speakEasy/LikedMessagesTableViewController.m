//  speakEasy
//
//  Created by Daljeet Virdi on 5/19/14.
//
//

#import "LikedMessagesTableViewController.h"
#import "PostStatusViewController.h"
#import "FriendPickerViewController.h"
#import "Constants.h"
#import "User.h"
#import "Message.h"
#import "MessageTableViewCell.h"
#import "Like.h"

@implementation LikedMessagesTableViewController

@synthesize spinner = _spinner;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-568h@2x.png"]];
    [self setTitle:@"Liked posts"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableData) name:USER_INFO_UPDATE object:nil];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.rowHeight = 80;
    
    /* Start spinner until data is loaded */
    [_spinner setHidesWhenStopped:YES];
    [_spinner startAnimating];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTableData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([[User currentUser] messagesBy]) {
        return [[User currentUser] likes].count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *currentUser = [User currentUser];
    if (currentUser == nil)
        return nil;
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likedMessageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    /* Configure label with message text */
    Like *like = [currentUser.likes objectAtIndex:indexPath.row];
    Message *message = like.message;
    cell.textLabel.text = message.text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = [UIColor lightTextColor];
    
    /* Configure guess button */
    if (cell.guessButton == nil) {
        cell.guessButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cell.guessButton.frame = CGRectMake(cell.contentView.frame.origin.x + 20, cell.contentView.frame.origin.y + 50, 41, 30);
        [cell.guessButton setTitle:@"guess" forState:UIControlStateNormal];
        //[cell.guessButton addTarget:self action:@selector(goToFriendPickerView:) forControlEvents:UIControlEventTouchUpInside];
        cell.guessButton.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.guessButton];
    }
    cell.guessButton.tag = indexPath.row;
    
    /* Configure score label */
    if (cell.scoreLabel == nil) {
        cell.scoreLabel = [[UILabel alloc] init];
        cell.scoreLabel.frame = CGRectMake(cell.contentView.frame.origin.x + 240, cell.contentView.frame.origin.y + 50, 41, 30);
        cell.scoreLabel.textColor = [UIColor lightTextColor];
        cell.scoreLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:cell.scoreLabel];
    }
    cell.scoreLabel.tag = indexPath.row;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%d", message.score];
    
    /* Configure like button */
    if (cell.likeButton == nil) {
        cell.likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cell.likeButton.frame = CGRectMake(cell.contentView.frame.origin.x + 270, cell.contentView.frame.origin.y + 50, 41, 30);
        [cell.likeButton setTitle:@"like" forState:UIControlStateNormal];
        //[cell.likeButton addTarget:self action:@selector(likeMessage:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeButton.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cell.likeButton];
    }
    cell.likeButton.tag = indexPath.row;
    
    return cell;
}

- (void)reloadTableData
{
    [self.tableView reloadData];
    if ([self.tableView numberOfRowsInSection:0] > 0) {
        [_spinner stopAnimating];
    }
}


@end
