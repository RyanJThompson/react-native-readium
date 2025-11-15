import { requireNativeComponent, UIManager } from 'react-native';

import type { BaseReadiumViewProps } from '../interfaces';
import { COMPONENT_NAME, LINKING_ERROR } from '../utils';

// @ts-expect-error - Codegen spec may not exist in old architecture
import ReadiumViewNativeComponent from '../specs/ReadiumViewNativeComponent';

const isFabricEnabled = () => {
  // Check if we're running on the new architecture
  return (
    global.nativeFabricUIManager != null &&
    // eslint-disable-next-line no-underscore-dangle
    global.nativeFabricUIManager.__enableFabric
  );
};

export const BaseReadiumView = isFabricEnabled()
  ? ReadiumViewNativeComponent
  : UIManager.getViewManagerConfig(COMPONENT_NAME) != null
  ? requireNativeComponent<BaseReadiumViewProps>(COMPONENT_NAME)
  : () => {
      throw new Error(LINKING_ERROR);
    };
