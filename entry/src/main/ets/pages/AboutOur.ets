@Entry
@Component
struct AboutOur {
  build() {
    Column() {
      //关于我们--页面
      Image($r("app.media.AboutOur"))
        .width(210)
        .height(165)
        .align(Alignment.Center)
        .margin({
          top: 65
        })
    }
    .height("100%")
    .width("100%")
  }
}