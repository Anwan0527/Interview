//题目列表组件
import { Request } from '../../common/utils/request'
import { QuestionItem, QuestionItemRow } from '../../models/QuestionItemModel'
import { QuestionItemComp } from './QuestionItemComp'
import { promptAction } from '@kit.ArkUI'


@Component
export struct QuestionListComp {
  qid: number = 0
  @State list: QuestionItemRow[] = []
  @State op: string = ''

  aboutToAppear() {
    this.getRow()
  }

  async getRow() {
    try {
      this.op = 'questionBankType=10&type=' + this.qid
      const res = await Request.get<QuestionItem>('question/list?' + this.op)
      this.list = res.data.rows!
      // promptAction.showToast({
      //   message: JSON.stringify(res.data)
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
        ForEach(this.list, (item: QuestionItemRow) => {
          ListItem() {
            QuestionItemComp({ item })
              .padding({ left: 10, right: 10 })

          }

        })
      }

    }
  }
}