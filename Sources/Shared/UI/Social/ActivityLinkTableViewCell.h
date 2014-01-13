//
//  ActivityLinkTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityBasicTableViewCell.h"

@interface ActivityLinkTableViewCell : ActivityBasicTableViewCell {
 
    EGOImageView*          _imgvAttach;
    RTLabel*     _htmlActivityMessage;
    RTLabel*     _htmlLinkTitle;
    RTLabel*     _htmlLinkDescription;
    RTLabel*     _htmlName;
    RTLabel*     _htmlLinkMessage;
    CGFloat width;
}

@property (retain) IBOutlet EGOImageView* imgvAttach;
@property (retain, nonatomic) RTLabel* htmlActivityMessage;
@property (retain, nonatomic) RTLabel* htmlLinkTitle;
@property (retain, nonatomic) RTLabel* htmlLinkDescription;
@property (retain, nonatomic) RTLabel* htmlName;
@property (retain, nonatomic) RTLabel* htmlLinkMessage;

@end
