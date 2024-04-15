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

  build() {
    Row() {
      Column() {
        Tabs() {
          TabContent() {
            Text('首页')
          }.tabBar(this.tabBuilder('首页', 0, $r("app.media.ic_tabbar_home"), $r("app.media.ic_tabbar_home_select")))

          TabContent() {
            Text('项目')
          }
          .tabBar(this.tabBuilder('项目', 1, $r("app.media.ic_tabbar_project"), $r("app.media.ic_tabbar_project_select")))

          TabContent() {
            Text('面经')
          }
          .tabBar(this.tabBuilder('面经', 2, $r("app.media.ic_tabbar_interview"), $r("app.media.ic_tabbar_interview_select")))

          TabContent() {
            Text('我的')
          }.tabBar(this.tabBuilder('我的', 3, $r("app.media.ic_tabbar_mine"), $r("app.media.ic_tabbar_mine_select")))
        }
        .animationDuration(0)
        .barPosition(BarPosition.End)
        .onChange(index => {
          this.currentIndex = index
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}