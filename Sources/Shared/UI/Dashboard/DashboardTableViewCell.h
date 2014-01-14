//
//  DashboardTableViewCell.h
//  eXo Platform
//
//  Created by Mai Gia on 1/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "CustomBackgroundForCell_iPhone.h"

@class EGOImageView;


@interface DashboardTableViewCell : CustomBackgroundForCell_iPhone {
    
    IBOutlet UILabel*               _lbDescription;
    IBOutlet UILabel*               _lbName;
    
    IBOutlet EGOImageView*          _imgvIcon;
    
    RTLabel*              _ttLabelDescription;
}


@property (retain, nonatomic)  UILabel* _lbDescription;
@property (retain, nonatomic)  UILabel* _lbName;
@property (retain, nonatomic)  EGOImageView* _imgvIcon;

-(void)configureCell:(NSString*)name description:(NSString*)description icon:(NSString*)iconURL;

@end
