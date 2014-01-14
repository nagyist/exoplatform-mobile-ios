//
//  HomeViewController_iPhone.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import "HomeViewController_iPhone.h"

#import "DocumentsViewController_iPhone.h"
#import "ActivityStreamBrowseViewController_iPhone.h"
#import "DashboardViewController_iPhone.h"
#import "SettingsViewController.h"
#import "FilesProxy.h"

#import "LanguageHelper.h"
#import "AppDelegate_iPhone.h"

@implementation HomeViewController_iPhone

@synthesize _isCompatibleWithSocial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = @"Home";
    }
    
    return self;
}

- (void)dealloc 
{
    [_launcherView release];
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    // Create a custom logout button    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barButtonImage = [UIImage imageNamed:@"HomeLogoutiPhone.png"];
    barButton.frame = CGRectMake(0, 0, barButtonImage.size.width, barButtonImage.size.height);
    [barButton setImage:[UIImage imageNamed:@"HomeLogoutiPhone.png"] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(onBbtnSignOut) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    [self.navigationItem setLeftBarButtonItem:customItem];
    [customItem release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadView 
{
    [super loadView];
    
    //Set the background Color of the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    
    //Force the status bar to be black opaque since TTViewController reset it
    //self.statusBarStyle = UIStatusBarStyleBlackOpaque;
    
    //Add the eXo logo to the Navigation Bar
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eXoLogoNavigationBariPhone.png"]];
    self.navigationItem.titleView = img;
    [img release];
    
    self.navigationItem.hidesBackButton = YES;
    
    //Set the title of the controller
    //TODO Localize that
    self.title = Localize(@"Home");
    
    //Add the bubble background
    /*UIImageView* imgBubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeBubbleBackground.png"]];
    imgBubble.frame = CGRectMake(0, self.view.frame.size.height-imgBubble.frame.size.height, imgBubble.frame.size.width, imgBubble.frame.size.height);
    [self.view addSubview:imgBubble];
    [imgBubble release];
    */
    /*
     
     //Add the shadow at the bottom of the navigationBar
     UIImageView *navigationBarShadowImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GlobalNavigationBarShadowIphone.png"]];
     navigationBarShadowImgV.frame = CGRectMake(0,0,navigationBarShadowImgV.frame.size.width,navigationBarShadowImgV.frame.size.height);
     [self.view addSubview:navigationBarShadowImgV];
     [navigationBarShadowImgV release];
     
     */
    
    if(_launcherView != nil){
        [_launcherView release];
    }
    
    _launcherView = [[UITableView alloc] initWithFrame:CGRectMake(0,5,self.view.frame.size.width, self.view.frame.size.height-120)];
    
    _launcherView.backgroundColor = [UIColor clearColor];
    _launcherView.delegate = self;
    _launcherView.dataSource = self;
    
    [self.view addSubview:_launcherView];
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

#pragma mark UITableview delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = Localize(@"News");
            cell.imageView.image = [UIImage imageNamed:@"HomeActivityStreamsIconiPhone.png"];
        }
            break;
        case 1:
        {
            cell.textLabel.text = Localize(@"Documents");
            cell.imageView.image = [UIImage imageNamed:@"HomeDocumentsIconiPhone.png"];
        }
            break;
        case 2:
        {
            cell.textLabel.text = Localize(@"Dashboard");
            cell.imageView.image = [UIImage imageNamed:@"HomeDashboardIconiPhone.png"];
        }
            break;
        case 3:
        {
            cell.textLabel.text = Localize(@"Settings");
            cell.imageView.image = [UIImage imageNamed:@"HomeSettingsIconiPhone.png"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ActivityStreamBrowseViewController_iPhone* _activityStreamBrowseViewController_iPhone = [[ActivityStreamBrowseViewController_iPhone alloc] initWithNibName:@"ActivityStreamBrowseViewController_iPhone" bundle:nil];
            [self.navigationController pushViewController:_activityStreamBrowseViewController_iPhone animated:YES];
            [_activityStreamBrowseViewController_iPhone release];
        }
            break;
        case 1:
        {
            //Start Documents
            DocumentsViewController_iPhone *documentsViewController = [[DocumentsViewController_iPhone alloc] initWithNibName:@"DocumentsViewController_iPhone" bundle:nil];
            [self.navigationController pushViewController:documentsViewController animated:YES];
            [documentsViewController release];
        }
            break;
        case 2:
        {
            //Start Dashboard
            
            DashboardViewController_iPhone *dashboardController = [[DashboardViewController_iPhone alloc] initWithNibName:@"DashboardViewController_iPhone" bundle:nil];
            [self.navigationController pushViewController:dashboardController animated:YES];
            [dashboardController release];
        }
            break;
        case 3:
        {
            SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
            settingsViewController.settingsDelegate = self;
            [settingsViewController startRetrieve];
            UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:settingsViewController] autorelease];
            [settingsViewController release];
            
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentModalViewController:navController animated:YES];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onBbtnSignOut
{
    [_delegate onBtnSigtOutDelegate];
    
    //Back to Login with a PopViewController
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma - Settings Delegate Methods
- (void)doneWithSettings {
//    NSArray *listItems = _launcherView.pages;
//    for (TTLauncherItem *item in listItems){
//        
//    }
    [self loadView];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}


@end
