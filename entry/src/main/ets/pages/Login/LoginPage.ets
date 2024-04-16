import { promptAction, router } from '@kit.ArkUI'
import { Auth } from '../../common/utils/Auth'
import { Logger } from '../../common/utils/Logger'
import { Request } from '../../common/utils/request'
import { UserLogin } from '../../models/UserLoginModel'
import { UserModel } from '../../models/UserModel'


@Entry
@Component
struct LoginPage {
  @State username: string = 'hmheima'
  @State password: string = 'Hmheima%123'
  @State isAgree: boolean = true //默认是false  现在设置true 是为了登陆方便
  @State loading: boolean = false

  async login() {
    try {
      if (!this.username) {
        return promptAction.showToast({
          message: "请输入用户名"
        })
      }
      if (!this.password) {
        return promptAction.showToast({
          message: "请输入密码"
        })
      }
      if (!this.isAgree) {
        return promptAction.showToast({ message: '请勾选已阅读并同意' })
      }
      this.loading = true
      const res = await Request.post<UserModel>('login', {
        username: this.username,
        password: this.password
      } as UserLogin)
      //存储用户Token等信息
      Auth.setUser(res.data)
      router.pushUrl({
        url: "/pages/Index".slice(1)
      })
      this.loading = false
    } catch (err) {
      Logger.error(JSON.stringify(err))
    }
  }

  build() {
    Column() {
      // logo
      Column({ space: 10 }) {
        Image($r('app.media.icon'))
          .height(55)
          .aspectRatio(1)

        Text('面试宝典')
          .fontSize(28)
          .fontColor('#121826')

        Text('搞定企业面试真题，就用面试宝典')
          .fontSize(14)
          .fontColor('#6F6F6F')
      }
      .margin({ top: 170 })

      //  登录区域
      Column({ space: 20 }) {

        TextInput({ text: $$this.username })
          .backgroundColor(Color.White)
          .width('90%')
          .borderRadius(0)

        TextInput({ text: $$this.password })
          .type(InputType.Password)
          .backgroundColor(Color.White)
          .width('90%')

        Row() {
          Checkbox()
            .select(this.isAgree)
            .selectedColor('#FA6D1D')
            .onChange(value => {
              this.isAgree = value
            })

          Text('已阅读并同意')
            .fontSize(14)
            .fontColor($r('app.color.ih_gray_color'))
            .padding({ right: 4 })
          Text('用户协议')
            .fontSize(14)
            .padding({ right: 4 })
          Text('和')
            .fontSize(14)
            .fontColor($r('app.color.ih_gray_color'))
            .padding({ right: 4 })
          Text('隐私政策')
            .fontSize(14)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/PreviewWebPage'
              })
            })
        }
        .width('90%')

        Button({ type: ButtonType.Normal }) {
          Row() {
            if (this.loading) {
              LoadingProgress()
                .height(28)
                .aspectRatio(1)
                .color(Color.White)
                .enableLoading(this.loading)
            }
            Text('登录')
              .onClick(() => {
                this.login()
              })
              .textAlign(TextAlign.Center)
          }
        }
        .borderRadius(4)
        .width(328)
        .height(45)
        .fontColor(Color.White)
        .linearGradient({
          angle: 135,
          colors: [
            ['#FCA21C', 0],
            ['#FA6D1D', 1]
          ]
        })

      }
      .margin({ top: 50 })

    }
    .width('100%')
    .height('100%')
  }
}