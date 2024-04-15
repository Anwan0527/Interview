//用于沉浸式类的封装
import { window } from '@kit.ArkUI'

export class windowManager {
  //设置状态栏文字颜色->白色
  static settingStatusBarLight() {
    window.getLastWindow(getContext())
      .then((windowStage: window.Window) => {
        //设置颜色
        windowStage.setWindowSystemBarProperties({
          statusBarContentColor: '#ffffff'
        })
      })
  }

  //设置状态栏文字颜色->黑色
  static settingStatusBarDark() {
    window.getLastWindow(getContext())
      .then((windowStage: window.Window) => {
        //设置颜色
        windowStage.setWindowSystemBarProperties({
          statusBarContentColor: '#000000'
        })
      })
  }

  //开启全屏
  static enableFullScreen() {
    //获取当前窗口对象,以及设置为全屏
    window.getLastWindow(getContext())
      .then((windowStage: window.Window) => {
        windowStage.setWindowLayoutFullScreen(true) //true  设置全屏
        //获取安全区高度并AppStoage存储
        const area = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
        AppStorage.setOrCreate('topHeight', area.topRect)
      })
  }

  //关闭全屏
  static disenableFullScreen() {
    //获取当前窗口对象,以及设置为全屏
    window.getLastWindow(getContext())
      .then((windowStage: window.Window) => {
        windowStage.setWindowLayoutFullScreen(false) //false  取消全屏
        //AppStoage存储
        AppStorage.setOrCreate('topHeight', 0)
      })
  }
}
