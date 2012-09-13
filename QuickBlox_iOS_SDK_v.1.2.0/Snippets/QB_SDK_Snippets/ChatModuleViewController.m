//
//  ChatModuleViewController.m
//  QB_SDK_Snippets
//
//  Created by kirill on 8/7/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#import "ChatModuleViewController.h"

@interface ChatModuleViewController ()

@end

@implementation ChatModuleViewController
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Chat", @"Chat");
        self.tabBarItem.image = [UIImage imageNamed:@"circle.png"];
        
        // set Chat delegate
        [[QBChat instance] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = 5;
            break;
        case 1:
            numberOfRows = 1;
            break;
        case 2:
            numberOfRows = 8;
            break;
    }
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* headerTitle;
    switch (section) {
        case 0:
            headerTitle = @"Sign In/Sign Out";
            break;
        case 1:
            headerTitle = @"1 to 1 chat";
            break;
        case 2:
            headerTitle = @"Rooms";
            break;
        default:
            headerTitle = @"";
            break;
    }
    return headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%d", indexPath.row];
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
            // section Sign In/Sign Out
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Login"];
                    break;
                    
                case 1:
                    [cell.textLabel setText:@"Is Logged In"];
                    break;
                    
                case 2:
                    [cell.textLabel setText:@"Logout"];
                    break;
                    
                case 3:
                    [cell.textLabel setText:@"Send presence"];
                    break;
                    
                case 4:
                    [cell.textLabel setText:@"Request user for presence"];
                    break;
                    
                default:
                    break;
            }
            break;
            
            // section 1 to 1 chat
        case 1:
            [cell.textLabel setText:@"Send message"];
            break;
            
            // section Rooms
        case 2:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Create room"];
                    break;
                    
                case 1:
                    [cell.textLabel setText:@"Join room"];
                    break;
                    
                case 2:
                    [cell.textLabel setText:@"Leave room"];
                    break;
                    
                case 3:
                    [cell.textLabel setText:@"Send message to room"];
                    break;
                    
                case 4:
                    [cell.textLabel setText:@"Request all rooms"];
                    break;
                    
                case 5:
                    [cell.textLabel setText:@"Request list of room's members"];
                    break;
                    
                case 6:
                    [cell.textLabel setText:@"Add users to room"];
                    break;
                    
                case 7:
                    [cell.textLabel setText:@"Delete users from room"];
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    switch (indexPath.section) {
        
        // Sign In/Sign Out
        case 0:
            switch (indexPath.row) {
                // Login
                case 0:{
                    QBUUser* user = [QBUUser user];
                    user.login = @"iostest";
                    user.ID = 292;
                    user.password = @"iostest2";
                    
                    BOOL success = [[QBChat instance] loginWithUser:user];
                }
                    
                break;
                    
                // Is logged in
                case 1:{
                    BOOL isLoggedIn = [[QBChat instance] isLoggedIn];
                        
                    NSLog(@"Is logged in: %d", isLoggedIn);
                }
                    break;
                    
                //  Logout
                case 2:{
                    BOOL success = [[QBChat instance] logout];
                }
                    break;
                    
                // Send presence
                case 3:
                    [[QBChat instance] sendPresence];
                    break;
                    
                // request user's presence
                case 4:{
                    QBUUser* user = [QBUUser user];
                    user.login = @"iostest";
                    user.ID = 292;
                    NSString* JID = [[QBChat instance] jidFromUser:user];
                    
                    [[QBChat instance] requestUserForPresence:JID];
                    break;
                }
                    
                default:
                    break;
            }
            break;
            
        // 1 to 1 chat
        case 1:
            switch (indexPath.row) {
                // send message
                case 0:{

                    QBChatMessage* message = [[QBChatMessage alloc] init];
                    [message setText:@"Hello iOS developer!"];
                    //
                    QBUUser* user = [QBUUser user];
                    user.login = @"iostest";
                    user.ID = 292;
                    NSString* JID = [[QBChat instance] jidFromUser:user];
                    //
                    [message setRecipientJID:JID];
                    [message setSenderJID:JID];
                    
                    [[QBChat instance] sendMessage:message];
                    
                    [message release];
                }
                default:
                    break;
            }
            break;
            
        // Rooms
        case 2:
            switch (indexPath.row) {
                // Create new room with name
                case 0:{
                    QBChatRoom* room = [[QBChat instance] newRoomWithName:@"IOS devs room4"];
                    
                    testRoom = room;
                }
                break;
                    
                // Join room
                case 1:{
                    [[QBChat instance] joinRoom:testRoom];
                }
                break;
                
                // Leave room
                case 2:{
                    [[QBChat instance] leaveRoom:testRoom];
                }
                break;
                    
                // Send message
                case 3:{
                    [[QBChat instance] sendMessage:@"Hi IOS devs4!" toRoom:testRoom];
                }
                break;
                
                // Request all rooms
                case 4:{
                    [[QBChat instance] requestAllRooms];
                }
                break;
                    
                // Request list of room's members
                case 5:{
                    [[QBChat instance] requestListOfMembersRoom:testRoom];
                }
                break;
                
                // Add users to room
                case 6:{
                    QBUUser* user = [QBUUser user];
                    user.login = @"iostest";
                    user.ID = 292;
                    NSString* JID = [[QBChat instance] jidFromUser:user];
                    NSArray* jids = [NSArray arrayWithObject:JID];
                    
                    [[QBChat instance] addUsers:jids toRoom:testRoom];
                }
                break; 
                
                // Delete users from room
                case 7:{
                    QBUUser* user = [QBUUser user];
                    user.login = @"iostest";
                    user.ID = 292;
                    NSString* JID = [[QBChat instance] jidFromUser:user];
                    NSArray* jids = [NSArray arrayWithObject:JID];
                    
                    [[QBChat instance] deleteUsers:jids fromRoom:testRoom];
                }
                break;
                
                default:
                    break;
            }
            
        default:
            break;
    }
}

    
#pragma mark -
#pragma mark QBChatDelegate

-(void) chatDidLogin{
    NSLog(@"Did login");
}

- (void)chatDidNotLogin{
    NSLog(@"Did not login");
}

- (void)chatDidReceivePresenceOfUser:(NSString *)jid{
    NSLog(@"Did receive presence of user %@",jid);
}

-(void)chatDidNotSendMessage:(QBChatMessage *)message{
    NSLog(@"Did not send message");
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    NSLog(@"Did receive message: %@, from %@", message.text, message.senderJID);
}

- (void)chatRoomDidCreated:(QBChatRoom*)room{
    NSLog(@"Room did created: %@", room.name);
}

- (void)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoom:(QBChatRoom *)room{
    NSLog(@"Did receive message: %@, from room %@", message.text, room.name);
}

- (void)chatDidReceiveListOfRooms:(NSArray *)_rooms{
    NSLog(@"Did receive list of rooms:");
    for (QBChatRoom* room in _rooms) {
        NSLog(@"%@",[room name]);
    }
}

- (void)chatDidReceiveListOfUsers:(NSArray *)users{
    NSLog(@"Did receive list of users :");
    for (QBUUser* user in users) {
        NSLog(@"%@",user.login);
    }
}

- (void)chatRoomDidChangeOccupants:(NSDictionary *)occupants room:(QBChatRoom *)room{
    NSLog(@"Room (%@) did change occupants: %@", room.name, occupants);
}

- (void)dealloc {
    [testRoom release];
    [super dealloc];
}
    
@end
