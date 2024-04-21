import { Request } from '../../common/utils/request'
import { QuestionItem, QuestionItemRow } from '../../models/QuestionItemModel'
import { QuestionItemComp } from '../home/QuestionItemComp'


@Component
export struct SearchResultListComp {
  @Prop @Watch('loadData') keyword: string = '' //作为一个服务器url请求的关键字来使用
  @State list: QuestionItemRow[] = [] // 题目数据列表

  async loadData() {
    // 根据关键字请求服务器数据显示
    let res = await Request.get<QuestionItem>(`question/list?questionBankType=10&keyword=${this.keyword}`)
    this.list = res.data.rows!
  }

  aboutToAppear(): void {
    this.loadData()
  }

  build() {
    Row() {

      List() {
        ForEach(this.list, (item: QuestionItemRow) => {
          ListItem() {
            QuestionItemComp({ item: item })
          }
        })
      }

    }
    .height("100%")
    .width("100%")
  }
}