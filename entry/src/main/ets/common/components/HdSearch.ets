//搜索组件
import { router } from '@kit.ArkUI'

@Component
export struct HdSearch {
  @State
  readonlyMode: boolean = true
  @State ph: string = 'html'
  bg: string = ''
  color: string = ''
  keyword = ['html', 'css', 'javascript', 'vue', 'react']
  count = 1
  intervalNum: number = -1

  aboutToAppear() {
    this.intervalNum = setInterval(() => {
      this.ph = this.keyword[this.count]
      this.count++
      if (this.count == this.keyword.length) {
        this.count = 0
      }
    }, 5000)
  }

  aboutToDisappear() {
    clearInterval(this.intervalNum)
  }

  build() {
    Row() {
      Row({ space: 4 }) {
        Image($r("app.media.ic_common_search"))
          .width($r('app.float.hd_search_icon_size'))
          .aspectRatio(1)
          .fillColor(this.color || $r('app.color.common_gray_02'))
        Text(this.ph || $r('app.string.hd_search_placeholder'))
          .fontColor(this.color || $r('app.color.common_gray_02'))
          .fontSize($r('app.float.common_font14'))
      }
      .layoutWeight(1)
      .height($r('app.float.hd_search_height'))
      .backgroundColor(this.bg || $r('app.color.common_gray_border'))
      .borderRadius($r('app.float.hd_search_radius'))
      .justifyContent(FlexAlign.Center)
    }.onClick(() => {
      router.pushUrl({
        url: 'pages/SearchPage',
        params: {
          keywordTxt: this.ph
        }
      })
    })
  }
}