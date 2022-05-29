//
//  Macro.h
//  LJYScrollKit
//
//  Created by 林君毅 on 2022/5/28.
//

#ifndef Macro_h
#define Macro_h

#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed : ((float)(((rgbValue) & 0xFF0000) >> 16)) / 255.0 \
green : ((float)(((rgbValue) & 0xFF00) >> 8)) / 255.0 \
blue : ((float)((rgbValue) & 0xFF)) / 255.0 \
alpha : 1.0]
#endif

#ifndef UIColorFromRGBA
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed : ((float)(((rgbValue) & 0xFF0000) >> 16)) / 255.0 \
green : ((float)(((rgbValue) & 0xFF00) >> 8)) / 255.0 \
blue : ((float)((rgbValue) & 0xFF)) / 255.0 \
alpha : alphaValue]
#endif


#endif /* Macro_h */
