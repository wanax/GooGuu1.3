/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle2

#import "/Applications/Injection Plugin.app/Contents/Resources/BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

#import "/Users/xcode/wanax/oc/GooGuu1.2-master/估股/Plugs/src/AOTag.m"


@interface InjectionBundle2 : NSObject
@end
@implementation InjectionBundle2

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    extern Class OBJC_CLASS_$_AOTag;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_AOTag notify:4];
    extern Class OBJC_CLASS_$_AOTagCloseButton;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_AOTagCloseButton notify:4];
    extern Class OBJC_CLASS_$_AOTagList;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_AOTagList notify:4];
    [bundleInjection loadedNotify:4];
}

@end

