import webview from '@ohos.web.webview'

@Entry
@Component
struct PreviewWebPage {
  webViewController: WebviewController = new webview.WebviewController()

  build() {
    Navigation() {
      Column() {
        Web({
          src: $rawfile('index.html'),
          controller: this.webViewController
        })
      }
    }
    .title("隐私政策")
    .titleMode(NavigationTitleMode.Mini)
  }
}