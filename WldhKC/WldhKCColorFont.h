//
//  ZdywColorFont.h
//  ZdywMini
//
//  Created by mini1 on 14-5-28.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#ifndef ZdywMini_WldhKCColorFont_h
#define ZdywMini_WldhKCColorFont_h

#define kColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kWldhNavigationBarTitleColor kColorFromRGB(0x000000)
#define kWldhNavigationBarTitleFont [UIFont boldSystemFontOfSize:18]

#define kWldhNavigationBarBgColor kColorFromRGB(0xFFFFFF)
#define kWldhNavigationBarTinitColor kColorFromRGB(0x333333)

#endif
