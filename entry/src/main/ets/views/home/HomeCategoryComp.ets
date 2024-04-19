// 题目分类组件
import { QuestionType, QuestionTypeModel } from '../../models/QuestionTypeModel'
import { promptAction } from '@kit.ArkUI'
import { Request } from '../../common/utils/request'
import { QuestionListComp } from './QuestionListComp'
import { FilterParams, QuestionFilterComp } from './QuestionFilterComp'
import { IvSkeleton } from '../../common/components/IvSkeleton'


@Component
export struct HomeCategoryComp {
  @State questionTypeList: QuestionTypeModel[] = []
  @State index: number = 0
  @State isShow: boolean = false //半模态
  @State params: FilterParams = { index: this.index, sort: 0, difficult: 0 } as FilterParams
  @State loading: boolean = false //骨架

  aboutToAppear() {
    this.getQuesionType()
  }

  async getQuesionType() {
    try {
      const res = await Request.get<QuestionTypeModel[]>('question/type')
      this.questionTypeList = res.data
      // promptAction.showToast({
      //   message: JSON.stringify(res.data)
      // })
    } catch (err) {
      promptAction.showToast({
        message: JSON.stringify(err)
      })
    }
  }

  @Builder
  SkeletonBuilder() {
    Column() {
      Row({ space: 15 }) {
        IvSkeleton()
        IvSkeleton({ widthValue: 60 })
        IvSkeleton({ widthValue: 80 })
      }
      .width('100%')
      .margin({ bottom: 15 })

      List({ space: 15 }) {
        ForEach([1, 2, 3, 4, 5, 6, 7], () => {
          ListItem() {
            Column({ space: 15 }) {
              Row({ space: 15 }) {
                IvSkeleton({ widthValue: 30 })
                IvSkeleton({ widthValue: '100%' }).layoutWeight(1)
              }

              Row({ space: 15 }) {
                IvSkeleton({ widthValue: 50 })
                IvSkeleton({ widthValue: 50 })
                IvSkeleton({ widthValue: 50 })
              }
              .width('100%')
            }
            .padding({ top: 10, bottom: 10 })
          }
        })
      }
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_bg') })
    }
    .width('100%')
    .padding(15)
    .layoutWeight(1)
  }

  @Builder
  filterBuilder() {
    Column() {
      QuestionFilterComp({
        questionTypeList: this.questionTypeList,
        params: this.params,
        onSubmit: (newparams: FilterParams) => {
          if (this.index !== newparams.index)
            this.index = newparams.index
          this.params = newparams
          this.isShow = false
        }
      })
    }
  }

  @Builder
  TabItemBuilder(q: QuestionTypeModel, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(q.name)
          .fontSize(15)
          .height(43)
          .fontColor(this.index === index ? Color.Black : Color.Gray)
        Text()
          .width(this.index === index ? 20 : 0)
          .height(2)
          .backgroundColor(Color.Black)
          .animation({ duration: this.index === index ? 300 : 0 })
      }
      .padding({ left: index === 0 ? 16 : 0, })

      if (q.displayNewestFlag === 1) {
        Image($r("app.media.ic_home_new"))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ right: this.questionTypeList.length === index + 1 ? 54 : 16 })
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) { //设置堆叠位置为右上角
      if (this.loading) {
        this.SkeletonBuilder()
      } else {
        Tabs({ index: this.index }) {
          ForEach(this.questionTypeList, (item: QuestionTypeModel, index: number) => {
            TabContent() {
              QuestionListComp({
                qid: item.id,
                selfIndex: index,
                activeIndex: this.index,
                params: this.params
              })
            }.tabBar(this.TabItemBuilder(item, index))
          })
        }
        .height(450)
        .divider({
          strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_border')
        }) //设置tabbar下面的横线样式
        .barMode(BarMode.Scrollable) // 设置tabs可以滚动
        .barHeight(44)
        .onChange(i => this.index = i) // 切换tabbar内容
      }


      Row() {
        // 过滤条件按钮
        Image($r('app.media.ic_home_filter'))
          .width(22)
          .height(44)
          .objectFit(ImageFit.Contain)// 设置图片按照容器大小填满
          .bindSheet(this.isShow, this.filterBuilder(), {
            height: 400,
            showClose: false,
            onDisappear: () => {
              this.isShow = false
            }
          })
          .onClick(() => {
            this.isShow = true
          })

      }
      .width(54)
      .height(44)
      .justifyContent(FlexAlign.Center) // 图片居中对齐
      .backgroundColor(Color.White) // 设置背景色位白色，使过滤条件图标能遮盖住tabbar的文字
    }
  }
}