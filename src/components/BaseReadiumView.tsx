import * as React from 'react';
import type { BaseReadiumViewProps } from '../interfaces';
import ReadiumViewNativeComponent from '../ReadiumViewNativeComponent';
import type {
  FileStruct,
  LocatorEvent,
  LinkEvent,
} from '../ReadiumViewNativeComponent';

// Convert public API types to native component props
function convertToNativeProps(props: BaseReadiumViewProps) {
  const {
    file,
    location,
    onLocationChange,
    onTableOfContents,
    ...restProps
  } = props;

  const nativeProps: any = {
    ...restProps,
  };

  // Convert File to FileStruct
  if (file) {
    const fileStruct: FileStruct = {
      url: file.url,
    };

    if (file.initialLocation) {
      const loc = file.initialLocation;
      fileStruct.initialLocationHref = loc.href;
      fileStruct.initialLocationTitle = loc.title || undefined;
    }

    nativeProps.file = fileStruct;
  }

  // Convert location to locationHref/locationTitle
  if (location) {
    nativeProps.locationHref = location.href;
    nativeProps.locationTitle = location.title || undefined;
  }

  // Convert event handlers
  if (onLocationChange) {
    nativeProps.onLocationChange = (event: { nativeEvent: LocatorEvent }) => {
      const locator = event.nativeEvent;
      onLocationChange(locator);
    };
  }

  if (onTableOfContents) {
    nativeProps.onTableOfContents = (event: {
      nativeEvent: { toc: readonly LinkEvent[] };
    }) => {
      const toc = event.nativeEvent.toc as any;
      onTableOfContents(toc);
    };
  }

  return nativeProps;
}

export const BaseReadiumView = React.forwardRef<any, BaseReadiumViewProps>(
  (props, ref) => {
    const nativeProps = convertToNativeProps(props);
    return <ReadiumViewNativeComponent {...nativeProps} ref={ref} />;
  }
);
