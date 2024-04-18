import { Logger } from '../../common/utils/Logger'
import { windowManager } from '../../common/utils/windowManager'
import router from '@ohos.router'
import { Request } from '../../common/utils/request'

import { promptAction } from '@kit.ArkUI'
import { User, UserModel } from '../../models/UserModel'
import { HdClockIn } from '../../common/components/HdClockIn'
import { TOKEN_KEY } from '../../common/constants/token_key'

PersistentStorage.PersistProp(TOKEN_KEY, "")

interface Nav {
  icon: ResourceStr
  name: string
  onClick?: () => void
  other?: string
}

interface Tool {
  icon: ResourceStr
  name: string
  value?: string
  onClick?: () => void
}

@Entry
@Component
export struct Mine {
  // 在AppStorage中获取到安全区域的高度数值
  @StorageProp('topHeight') toHeight: number = 0
  @State clockCount: number = 0
  @State Userlist: Partial<UserModel> = {} as User

  async updateUser() { //获取
    // promptAction.showToast({
    //   message: JSON.stringify(Auth.getUser().token)
    // })
    try {
      const res = await Request.get<UserModel>('userInfo') //获取个人信息
      this.Userlist = res.data
    } catch (err) {
      promptAction.showToast({
        message: JSON.stringify(err)
      })
    }

  }

  @Builder
  toolsBuilder(tool: Tool) {
    Row() {
      Image(tool.icon)
        .width(16)
        .aspectRatio(1)
        .margin({ right: 12 })
      Text(tool.name)
        .fontSize(14)
      Blank()
      if (tool.value) {
        Text(tool.value)
          .fontSize(12)
          .fontColor($r("app.color.common_gray_01"))
      }
      Image($r("sys.media.ohos_ic_public_arrow_right"))
        .width(16)
        .aspectRatio(1)
        .fillColor($r("app.color.common_gray_01"))
    }
    .height(50)
    .width("100%")
    .padding({
      left: 16,
      right: 10
    })
  }

  @Builder
  navBuilder(nav: Nav) {
    GridCol() {
      Column() {
        Image(nav.icon)
          .width(23)
          .aspectRatio(1)
          .margin({ bottom: 10 })
        Text(nav.name)
          .fontSize(12)
          .fontColor($r("app.color.common_gray_01"))
          .margin({ bottom: 4 })
        if (nav.other) {
          Row() {
            Text(nav.other)
              .fontSize(12)
              .fontColor($r("app.color.common_gray_01"))
            Image($r("sys.media.ohos_ic_public_arrow_right"))
              .width(12)
              .aspectRatio(1)
              .fillColor($r("app.color.common_gray_01"))
          }
        }
      }
      .onClick(() => {
        nav.onClick && nav.onClick()
      })
    }
  }

  // 进入页面
  aboutToAppear(): void {

    windowManager.settingStatusBarLight() // 开启当前页面的状态栏文字颜色为白色
    // this.getUserList()
    this.updateUser()
  }

  // 离开页面
  aboutToDisappear(): void {
    Logger.info('aboutToDisappear触发')
    windowManager.settingStatusBarDark() // 离开页面后就将状态栏颜色设置为黑色
  }

  build() {
    Column({
      space: 16
    }) {
      Row({
        space: 12
      }) {
        //头像
        Image(this.Userlist.avatar)// Image($r("app.media.ic_mine_avatar"))
          .width(55)
          .aspectRatio(1)
          .borderRadius(55)
        // .backgroundColor("#FFC4C4C4")
        Column({
          space: 4
        }) {
          //微信用户
          Text(this.Userlist.nickName)
            .fontSize(18)
            .fontWeight(500)
            .width("100%")
            .margin({
              bottom: 5
            })
          //编辑信息
          Row() {
            Text("编辑个人信息")
              .fontColor($r("app.color.ih_gray_color"))
              .fontSize(11)
              .margin({ right: 4 })
            //小图标
            Image($r("app.media.icon_edit"))
              .width(10)
              .height(10)
              .fillColor($r("app.color.ih_gray_color"))
          }
          .width("100%")
          .onClick(() => {
            //todo 跳转修改页面
            router.pushUrl({
              url: "跳转修改页面"
            })
          })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        //打卡
        HdClockIn()
      }
      .width("100%")
      .height(100)

      //历史记录、我的收藏、我的点赞、累计学识
      GridRow({
        columns: 4
      }) {
        this.navBuilder({
          icon: $r("app.media.ic_mine_history"), name: '历史记录'
        })
        this.navBuilder({
          icon: $r("app.media.ic_mine_collect"), name: '我的收藏'
        })
        this.navBuilder({
          icon: $r("app.media.ic_mine_like"), name: '我的点赞'
        })
        this.navBuilder({
          icon: $r("app.media.ic_mine_study"),
          name: '累计学识',
          other: `${this.Userlist.totalTime}小时`,
          onClick: () => {
            router.pushUrl({ url: "跳转学时页面" }) //todo  跳转学时页面
          }
        })
      }
      .width("100%")
      .backgroundColor(Color.White)
      // .backgroundColor(Color.Pink)
      .padding(16)
      .borderRadius(8)

      //前端常用词
      Column() {
        this.toolsBuilder({ icon: $r('app.media.ic_mine_notes'), name: '前端常用词' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_ai'), name: '面通AI' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_invite'), name: '推荐分享' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_file'), name: '意见反馈' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_info'), name: '关于我们' })
        this.toolsBuilder({ icon: $r('app.media.ic_mine_setting'), name: '设置' })
      }
      .backgroundColor(Color.White)
      .borderRadius(8)
    }
    .backgroundColor($r("app.color.common_gray_bg"))
    .width('100%')
    .height('100%')
    .padding($r('app.float.common_gutter')) // 动态设置
    .linearGradient({
      colors: [['#FFB071', 0], ['#f3f4f5', 0.3], ['#f3f4f5', 1]]
    })
  }
}