//题目列表组件
import { Request } from '../../common/utils/request'
import { QuestionItem, QuestionItemRow } from '../../models/QuestionItemModel'
import { QuestionItemComp } from './QuestionItemComp'
import { promptAction } from '@kit.ArkUI'
import { LoadingDialog } from '../../common/components/LoadingDialog'


@Component
export struct QuestionListComp {
  qid: number = 0
  @State list: QuestionItemRow[] = []
  @State op: string = ''
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State page: number = 1
  timeoutId = -1
  @State message: string = '获取中ing'
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: this.message }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  aboutToAppear() {
    this.getRow()
  }

  async getRow() {
    try {
      this.dialog.open() //打开提示框
      if (this.isLoadingMore) this.page++
      this.op = `questionBankType=10&type=${this.qid}&page=${this.page}`
      const res = await Request.get<QuestionItem>('question/list?' + this.op)

      if (this.isLoadingMore) {
        this.list.push(...res.data.rows!)
      } else {
        this.list = res.data.rows!
      }
      this.isLoadingMore = false
      this.isRefreshing = false
      this.dialog.close() //关闭提示框
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
          this.timeoutId = setTimeout(() => {
            this.isLoadingMore = true
            this.getRow()

          })

        })
      }
      .onRefreshing(() => {
        // this.isRefreshing = true
        this.page = 1 // 刷新拉到第一页
        this.getRow()

      }) //刷新 直到列表生成后 结束刷新

    }
  }
}