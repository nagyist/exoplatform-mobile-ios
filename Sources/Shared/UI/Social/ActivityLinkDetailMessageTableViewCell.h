//
//  ActivityLinkDetailMessageTableViewCell.h
//  eXo Platform
//
//  Created by Nguyen Khac Trung on 11/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailMessageTableViewCell.h"

@interface ActivityLinkDetailMessageTableViewCell : ActivityDetailMessageTableViewCell{

    RTLabel*      _htmlLinkTitle;
    RTLabel*     _htmlLinkMessage;
    RTLabel*     _htmlActivityMessage;
    
    CGFloat width;
}
@property (retain, nonatomic) RTLabel* htmlActivityMessage;
@property (retain, nonatomic) RTLabel* htmlLinkTitle;
@property (retain, nonatomic) RTLabel* htmlLinkMessage;
- (void)configureCellForSpecificContentWithWidth:(CGFloat)fWidth;

@end
