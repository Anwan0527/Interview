import webview from '@ohos.web.webview'

@Entry
@Component
struct PreviewWebPage {
  webViewController: webview.WebviewController = new webview.WebviewController()

  build() {
    Column() {
      Web({
        src: $rawfile('index.html'),
        controller: this.webViewController
      })
    }
  }
}