import { Logger } from '../../common/utils/Logger'
import { windowManager } from '../../common/utils/windowManager'

@Component
export struct Mine {
  // 在AppStorage中获取到安全区域的高度数值
  @StorageProp('topHeight') toHeight: number = 0

  // 进入页面
  aboutToAppear(): void {
    windowManager.settingStatusBarLight() // 开启当前页面的状态栏文字颜色为白色
  }

  // 离开页面
  aboutToDisappear(): void {
    Logger.info('aboutToDisappear触发')
    windowManager.settingStatusBarDark() // 离开页面后就将状态栏颜色设置为黑色
  }

  build() {
    Column() {
      Text('我的页面')
    }
    .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')
    .padding({ top: this.toHeight }) // 动态设置
  }
}