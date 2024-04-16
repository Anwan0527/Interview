import { HdClockIn } from './HdClockIn'
import { HdSearch } from './HdSearch'
import { promptAction } from '@kit.ArkUI'
import { Request } from '../../common/utils/request'
import { UserModel } from '../../models/UserModel'
import { HomeCategoryComp } from './HomeCategoryComp'

@Component
export struct Home {
  @StorageProp('topHeight') topHeight: number = 0
  @State clockCountNum: number = 0

  aboutToAppear() {
    this.getClockInfo()
  }

  //获取打卡数据方法
  async getClockInfo() {
    try {

      const res = await Request.get<UserModel>('clockinInfo')
      this.clockCountNum = res.data.clockinNumbers!
    } catch (err) {
      promptAction.showToast({
        message: JSON.stringify(err)
      })
    }
  }

  build() {
    Column() {
      Row({ space: 15 }) {
        //1.搜索
        HdSearch()
          .layoutWeight(3)

        //2.打卡
        HdClockIn({ clockCount: this.clockCountNum })
          .layoutWeight(1)

      }

      //轮播图
      Swiper() {
        Image($r('app.media.banner_qa'))
          .objectFit(ImageFit.Fill)
          .height(200)

        Image($r('app.media.banner_pj'))
          .objectFit(ImageFit.Fill)
          .height(200)

        Image($r('app.media.banner_ai'))
          .objectFit(ImageFit.Fill)
          .height(200)
      }
      .padding(10)
      .autoPlay(true)
      .indicator(DotIndicator.dot()
        .selectedColor(Color.White)
        .bottom(20))

      //题目分类组件
      HomeCategoryComp()

    }
    .width("100%")
    .height("100%")
    .padding({
      top: this.topHeight
    })
  }
}