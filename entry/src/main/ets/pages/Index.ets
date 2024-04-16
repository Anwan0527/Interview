import { windowManager } from '../common/utils/windowManager'
import { Home } from '../views/home/Home'
import { Mine } from '../views/mine/Mine'


@Entry
@Component
struct Index {
  @State
  currentIndex: number = 0

  @Builder
  tabBuilder(text: string, index: number, icon: ResourceStr, selectedicon: ResourceStr,) {
    Column({ space: 5 }) {
      Image(this.currentIndex == index ? selectedicon : icon)
        .height(28)
        .aspectRatio(1)

      Text(text)
    }
  }

  aboutToAppear(): void {
    // Auth.initLocalUser()
    windowManager.enableFullScreen() //开启沉浸式
  }

  build() {
    Row() {
      Column() {
        Tabs() {
          TabContent() {
            if (this.currentIndex == 0) {
              Home()
            }
          }.tabBar(this.tabBuilder('首页', 0, $r("app.media.tabbar_home"), $r("app.media.tabbar_home_fill")))

          TabContent() {
            if (this.currentIndex == 1) {
              Text('项目')
            }
          }
          .tabBar(this.tabBuilder('项目', 1, $r("app.media.tabbar_project"), $r("app.media.tabbar_project_fill")))

          TabContent() {
            if (this.currentIndex == 2) {
              Text('面经')
            }
          }
          .tabBar(this.tabBuilder('面经', 2, $r("app.media.tabbar_interview"), $r("app.media.tabbar_interview_fill")))

          TabContent() {
            if (this.currentIndex == 3) {
              Mine()
            }
          }.tabBar(this.tabBuilder('我的', 3, $r("app.media.tabbar_mine"), $r("app.media.tabbar_mine_fill")))
        }
        .animationDuration(0)
        .barPosition(BarPosition.End)
        .onChange(index => {
          this.currentIndex = index
        })
      }
      .margin({
        bottom: 15
      })
      .width('100%')
    }
    .height('100%')
  }
}