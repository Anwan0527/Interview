@Entry
@Component
struct WechatLoginPage {
  build() {
    Column() {
      //面试宝典图片
      Image($r("app.media.wechatLogin"))
        .width(210)
        .height(146)
        .margin({
          top: 170,
          bottom: 240
        })
      //登陆按钮
      Text("微信登陆")
        .width(328)
        .height(45)
        .textAlign(TextAlign.Center)
        .linearGradient({
          angle: 135,
          colors: [
            ['#FCA21C', 0],
            ['#FA6D1D', 1]
          ]
        })
    }
    .align(Alignment.Center)

    .width("100%")
  }
}