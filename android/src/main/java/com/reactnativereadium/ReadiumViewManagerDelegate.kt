package com.reactnativereadium

import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.BaseViewManagerDelegate
import com.facebook.react.uimanager.BaseViewManagerInterface
import com.facebook.react.viewmanagers.ReadiumViewManagerDelegate
import com.facebook.react.viewmanagers.ReadiumViewManagerInterface

class ReadiumViewManagerDelegate<T : ReadiumView, U : BaseViewManagerInterface<T> & ReadiumViewManagerInterface<T>>(
  viewManager: U
) : BaseViewManagerDelegate<T, U>(viewManager), ReadiumViewManagerDelegate<T, U> {

  override fun setProperty(view: T, propName: String, value: Any?) {
    when (propName) {
      "file" -> {
        mViewManager.setFile(view, value as? ReadableMap)
      }
      "location" -> {
        mViewManager.setLocation(view, value as? ReadableMap)
      }
      "preferences" -> {
        mViewManager.setPreferences(view, value as? String ?: "")
      }
      "height" -> {
        mViewManager.setHeight(view, value as? Int ?: 0)
      }
      "width" -> {
        mViewManager.setWidth(view, value as? Int ?: 0)
      }
      else -> super.setProperty(view, propName, value)
    }
  }
}
