// 打卡组件
import { Request } from '../utils/request'
import { promptAction, router } from '@kit.ArkUI'
import { ClockinModel } from '../../models/ClockinModel'
import { TOKEN_KEY } from '../constants/token_key'
import http from '@ohos.net.http'


PersistentStorage.persistProp(TOKEN_KEY, "")

@Component
export struct HdClockIn {
  @Prop
  clockCount: number = 0
  @StorageProp(TOKEN_KEY) token: string = ''

  async ClockIn() {
    try {
      const res = await Request.post<ClockinModel>('clockin')
      this.clockCount = res.data.clockinNumbers
    }
    catch (err) {
      promptAction.showToast({
        message: "有问题"
      })
    }
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Image(this.clockCount > 0 ? $r('app.media.clocked') : $r('app.media.unclock'))
        .objectFit(ImageFit.Fill)
      if (this.clockCount > 0) {
        Column() {
          Text('已连续打卡')
            .fontSize(8)
          Text() {
            Span(this.clockCount.toString())
              .fontWeight(600)
              .fontSize(12)
            Span(' 天')
              .fontSize(10)
          }
        }
        .onClick(() => {
          router.pushUrl({
            url: '/pages/Clickin/ClickinPage'.slice(1)
          })
        })
        .width('50')
      } else {
        Text('打卡')
          .width('50')
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .fontWeight(500)
          .fontColor('#333C4F')
          .margin({ bottom: (4) })
          .onClick(() => {
            this.ClockIn()
          })
      }
    }
    .width((74))
    .height((28))
  }
}