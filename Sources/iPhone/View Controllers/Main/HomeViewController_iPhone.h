//
//  HomeViewController_iPhone.h
//  eXo Platform
//
//  Created by Tran Hoai Son on 4/22/11.
//  Copyright 2011 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface HomeViewController_iPhone : UIViewController <UITableViewDelegate,UITableViewDataSource,SettingsDelegateProcotol> {
    id                  _delegate;
    UITableView*     _launcherView;
        
    BOOL                _isCompatibleWithSocial;
        
}

@property BOOL _isCompatibleWithSocial;

- (void)setDelegate:(id)delegate;
@end
