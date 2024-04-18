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
  @State isRefreshing: boolean = false
  @State page: number = 1

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
      Refresh({ refreshing: $$this.isRefreshing }) {
        List() {
          ForEach(this.list, (item: QuestionItemRow) => {
            ListItem() {
              QuestionItemComp({ item })
                .padding({ left: 10, right: 10 })
            }
          })
        }
      }
      .onRefreshing(async () => {
        await this.getRow()
        this.isRefreshing = false
      }) //刷新 直到列表生成后 结束刷新

    }
  }
}