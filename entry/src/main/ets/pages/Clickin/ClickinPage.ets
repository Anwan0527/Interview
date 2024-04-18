import { HmCalendar, HmCalendarSelectedDay } from '@ohmos/calendar'
import { promptAction } from '@kit.ArkUI'

import { Request } from '../../common/utils/request'
import { GetClockinModel } from '../../models/GetClockinModel'
import { TOKEN_KEY } from '../../common/constants/token_key'

PersistentStorage.persistProp(TOKEN_KEY, "")


interface DayBuilderParams {
  day: number
  text: string
}


@Entry
@Component
export struct ClockPage {
  @State createAtList: HmCalendarSelectedDay[] = []
  @State totalClockinNumber: number = 0 //累计打卡
  @State clockinNumbers: number = 0 //连续打卡
  @StorageProp('topHeight') topHeight: number = 0


  aboutToAppear() {

    this.getClockInfo()

  }

  //获取打卡数据方法
  async getClockInfo() {

    try {
      const res = await Request.get<GetClockinModel>('clockinInfo')
      this.clockinNumbers = res.data.clockinNumbers
      this.totalClockinNumber = res.data.totalClockinNumber
      this.createAtList = res.data.clockins.map(item => {
        return { date: item.createdAt } as HmCalendarSelectedDay
      })

    } catch (err) {
      promptAction.showToast({
        message: JSON.stringify(err)
      })
    }
  }

  // 累计打卡、连续打卡公共布局
  @Builder
  dayBuilder(params: DayBuilderParams) {
    Column() {
      Row() {
        Text(params.day.toString())
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
        Text('天')
          .fontSize(10)
          .fontColor($r('app.color.common_gray_01'))
          .margin({ bottom: 8, left: 10 })
      }
      .alignItems(VerticalAlign.Bottom)

      Text(params.text)
        .fontSize(10)
        .fontColor($r('app.color.common_gray_01'))
    }.margin({ right: 36 })
  }

  build() {
    Navigation() {
      Column({ space: 16 }) {
        Row() {
          this.dayBuilder({ day: this.totalClockinNumber, text: '累计打卡' })
          this.dayBuilder({ day: this.clockinNumbers, text: '连续打卡' })
        }
        .padding({ top: 10, bottom: 25, left: 16, right: 16 })
        .width('100%')
        .justifyContent(FlexAlign.Start)

        Row() {
          HmCalendar({
            selectedDays: this.createAtList,
            // 切换月份更新当前月份打卡数据
            onChangeMonth: (yearmonth: string) => {
              promptAction.showToast({ message: yearmonth })
            },
            // 点击当前日期触发 2024-01-24
            onClickDate: (currentDate: string) => {
              promptAction.showToast({ message: currentDate })
            }
          })
            .borderRadius(8)
            .border({ width: 0.5, color: '#ededed' })
            .shadow({ color: '#ededed', radius: 16 })
            .backgroundColor('#FFFFFF')
        }
        .padding({ left: 16, right: 16 })

      }
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.clocked_bg'))
      .backgroundImageSize({ width: '100%' })
    }
    .title('每日打卡')
    .titleMode(NavigationTitleMode.Mini)
    .padding({
      top: this.topHeight
    })

  }
}