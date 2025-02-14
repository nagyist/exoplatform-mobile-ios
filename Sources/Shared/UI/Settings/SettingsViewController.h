//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import <UIKit/UIKit.h>
#import "LoginProxy.h"
#import "PlatformServerVersion.h"
#import "eXoTableViewController.h"
#import "WelcomeViewController.h"

@class UserPreferencesManager;

@protocol ServerManagerProtocol <NSObject>
- (BOOL)addServerObjWithServerName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)editServerObjAtIndex:(int)index withSeverName:(NSString*)strServerName andServerUrl:(NSString*)strServerUrl withUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)deleteServerObjAtIndex:(int)index;
@end

@protocol SettingsDelegateProcotol

-(void)doneWithSettings;

@end

@interface SettingsViewController : eXoTableViewController <LoginProxyDelegate, ServerManagerProtocol, WelcomeViewControllerDelegate> {
    
    BOOL                            bVersionServer;
	NSString*                       languageStr;
	
	UISwitch*                       rememberMe;
	UISwitch*                       autoLogin;
    UISwitch*                       _rememberSelectedStream;
    UISwitch*                       _showPrivateDrive;
    
    id<SettingsDelegateProcotol>    _settingsDelegate;
    
    NSMutableArray                  *_listOfSections;
    
}

@property (assign) id<SettingsDelegateProcotol>    settingsDelegate;


-(void)startRetrieve;
-(void)enableDisableAutoLogin:(id)sender;

@end
