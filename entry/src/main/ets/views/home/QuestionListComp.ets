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
  @State isLoadingMore: boolean = false
  @State page: number = 1
  timeoutId = -1

  aboutToAppear() {
    this.getRow()
  }

  async getRow() {
    try {
      if (this.isLoadingMore) this.page++
      this.op = `questionBankType=10&type=${this.qid}&page=${this.page}`
      const res = await Request.get<QuestionItem>('question/list?' + this.op)

      if (this.isLoadingMore) {
        this.list.push(...res.data.rows!)
      } else {
        this.list = res.data.rows!
      }

      // if (this.page > 1) {
      //   this.list.push(...res.data.rows!)
      // }
      // else {
      //   this.list = res.data.rows!
      // }
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
        //上拉获取更多
        .onReachEnd(() => {
          // this.isLoadingMore = true
          clearTimeout(this.timeoutId)
          this.timeoutId = setTimeout(async () => {
            this.isLoadingMore = true
            await this.getRow()
            this.isLoadingMore = false
          })

        })
      }
      .onRefreshing(async () => {
        // this.isRefreshing = true
        this.page = 1 // 刷新拉到第一页
        await this.getRow()
        this.isRefreshing = false
      }) //刷新 直到列表生成后 结束刷新

    }
  }
}