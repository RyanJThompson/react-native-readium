#ifdef RCT_NEW_ARCH_ENABLED
#import "ReadiumViewComponentView.h"

#import <react/renderer/components/RNReadiumSpec/ComponentDescriptors.h>
#import <react/renderer/components/RNReadiumSpec/EventEmitters.h>
#import <react/renderer/components/RNReadiumSpec/Props.h>
#import <react/renderer/components/RNReadiumSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"
#import <React/RCTConversions.h>

#if __has_include(<react_native_readium/react_native_readium-Swift.h>)
#import <react_native_readium/react_native_readium-Swift.h>
#else
#import "react-native-readium-Swift.h"
#endif

using namespace facebook::react;

@interface ReadiumViewComponentView () <RCTReadiumViewViewProtocol>
@end

@implementation ReadiumViewComponentView {
  ReadiumView *_view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
  return concreteComponentDescriptorProvider<ReadiumViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ReadiumViewProps>();
    _props = defaultProps;

    _view = [[ReadiumView alloc] init];

    self.contentView = _view;

    // Set up event handlers once during initialization
    [self setupEventHandlers];
  }

  return self;
}

- (void)setupEventHandlers
{
  __weak __typeof(self) weakSelf = self;

  _view.onLocationChange = ^(NSDictionary *event) {
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf != nullptr && strongSelf->_eventEmitter != nullptr) {
      auto emitter = std::static_pointer_cast<ReadiumViewEventEmitter const>(strongSelf->_eventEmitter);

      // Convert NSDictionary to event struct
      facebook::react::ReadiumViewEventEmitter::OnLocationChange eventData = {};

      if (event[@"href"]) {
        eventData.href = std::string([event[@"href"] UTF8String]);
      }
      if (event[@"type"]) {
        eventData.type = std::string([event[@"type"] UTF8String]);
      }
      if (event[@"target"]) {
        eventData.target = [event[@"target"] intValue];
      }
      if (event[@"title"]) {
        eventData.title = std::string([event[@"title"] UTF8String]);
      }

      // Handle flattened location properties (codegen compatibility)
      if (event[@"locations"]) {
        NSDictionary *locations = event[@"locations"];

        if (locations[@"progression"]) {
          eventData.progression = [locations[@"progression"] doubleValue];
        }
        if (locations[@"position"]) {
          eventData.position = [locations[@"position"] intValue];
        }
        if (locations[@"totalProgression"]) {
          eventData.totalProgression = [locations[@"totalProgression"] doubleValue];
        }
      }

      emitter->onLocationChange(eventData);
    }
  };

  _view.onTableOfContents = ^(NSDictionary *event) {
    __typeof(self) strongSelf = weakSelf;
    if (strongSelf != nullptr && strongSelf->_eventEmitter != nullptr) {
      auto emitter = std::static_pointer_cast<ReadiumViewEventEmitter const>(strongSelf->_eventEmitter);

      facebook::react::ReadiumViewEventEmitter::OnTableOfContents eventData = {};

      if (event[@"toc"]) {
        NSArray *tocArray = event[@"toc"];
        std::vector<std::string> tocVector;

        for (NSDictionary *link in tocArray) {
          // Convert dictionary to JSON string for codegen compatibility
          NSError *error = nil;
          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:link options:0 error:&error];
          if (jsonData && !error) {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            tocVector.push_back(std::string([jsonString UTF8String]));
          }
        }

        eventData.toc = tocVector;
      }

      emitter->onTableOfContents(eventData);
    }
  };
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
  const auto &oldViewProps = *std::static_pointer_cast<ReadiumViewProps const>(_props);
  const auto &newViewProps = *std::static_pointer_cast<ReadiumViewProps const>(props);

  // Handle file prop
  if (oldViewProps.file != newViewProps.file) {
    if (newViewProps.file.has_value()) {
      auto fileStruct = newViewProps.file.value();
      NSMutableDictionary *fileDict = [[NSMutableDictionary alloc] init];

      if (!fileStruct.url.empty()) {
        fileDict[@"url"] = RCTNSStringFromString(fileStruct.url);
      }

      if (fileStruct.initialLocationHref.has_value() && !fileStruct.initialLocationHref.value().empty()) {
        NSMutableDictionary *initialLocation = [[NSMutableDictionary alloc] init];
        initialLocation[@"href"] = RCTNSStringFromString(fileStruct.initialLocationHref.value());

        if (fileStruct.initialLocationTitle.has_value() && !fileStruct.initialLocationTitle.value().empty()) {
          initialLocation[@"title"] = RCTNSStringFromString(fileStruct.initialLocationTitle.value());
        }

        fileDict[@"initialLocation"] = initialLocation;
      }

      _view.file = fileDict;
    }
  }

  // Handle location props
  if (oldViewProps.locationHref != newViewProps.locationHref ||
      oldViewProps.locationTitle != newViewProps.locationTitle) {
    if (newViewProps.locationHref.has_value() && !newViewProps.locationHref.value().empty()) {
      NSMutableDictionary *locationDict = [[NSMutableDictionary alloc] init];
      locationDict[@"href"] = RCTNSStringFromString(newViewProps.locationHref.value());

      if (newViewProps.locationTitle.has_value() && !newViewProps.locationTitle.value().empty()) {
        locationDict[@"title"] = RCTNSStringFromString(newViewProps.locationTitle.value());
      }

      _view.location = locationDict;
    }
  }

  // Handle preferences prop
  if (oldViewProps.preferences != newViewProps.preferences) {
    if (newViewProps.preferences.has_value() && !newViewProps.preferences.value().empty()) {
      _view.preferences = RCTNSStringFromString(newViewProps.preferences.value());
    }
  }

  [super updateProps:props oldProps:oldProps];
}

- (void)prepareForRecycle
{
  [super prepareForRecycle];
  _view.file = nil;
  _view.location = nil;
  _view.preferences = nil;
}

@end

Class<RCTComponentViewProtocol> ReadiumViewCls(void)
{
  return ReadiumViewComponentView.class;
}

#endif
