//题目列表组件
import { QuestionItemComp } from './QuestionItemComp'
import { promptAction } from '@kit.ArkUI'
import { Request } from '../../common/utils/request'
import { QuestionItem, QuestionItemModel, QuestionItemRow, QuestionItemRowModel } from '../../models/QuestionItemModel'


@Component
export struct QuestionListComp {
  @State QuestionList: QuestionItemRowModel[] = []
  @Prop
  questionType: number
  @Prop
  @Watch('initQuestionList')
  activeIndex: number
  @Prop
  selfIndex: number

  aboutToDisappear() {
    this.initQuestionList()
  }

  initQuestionList() {
    if (this.activeIndex === this.selfIndex && this.QuestionList.length === 0) {
      this.getQuestionList()
    }
  }

  async getQuestionList() {
    try {
      // promptAction.showToast({
      //   message: "触发了"
      // })
      const res = await Request.get<QuestionItemModel>('question/list')
      this.QuestionList = res.data.rows!
      // promptAction.showToast({
      //   message: JSON.stringify(this.QuestionList)
      // })
    } catch (err) {
      promptAction.showToast({
        message: JSON.stringify(err)
      })
    }
  }

  build() {
    Column() {
      List() {
        ForEach(this.QuestionList, (item: QuestionItemRowModel) => {
          ListItem() {
            QuestionItemComp({ item })
            // .padding({ left: 10, right: 10 })
          }

        })
      }

    }
  }
}