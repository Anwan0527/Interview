//题目列表组件
import { Request } from '../../common/utils/request'
import { QuestionItem, QuestionItemRow } from '../../models/QuestionItemModel'
import { QuestionItemComp } from './QuestionItemComp'
import { promptAction, router } from '@kit.ArkUI'
import { LoadingDialog } from '../../common/components/LoadingDialog'
import { FilterParams } from './QuestionFilterComp'


@Component
export struct QuestionListComp {
  qid: number = 0
  @State questionList: QuestionItemRow[] = []
  @State op: string = ''
  @State isRefreshing: boolean = false
  @State isLoadingMore: boolean = false
  @State page: number = 0
  timeoutId = -1
  @State message: string = '获取中ing'
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: this.message }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @Prop
  @Watch('getQuestionList')
  activeIndex: number
  @Prop
  selfIndex: number
  @Prop
  @Watch('getQuestionList')
  params: FilterParams = {} as FilterParams
  @Watch('getQuestionList')
  @Prop isort: number = 0
  @Prop Project: boolean = false

  // aboutToAppear() {
  //   this.getQuestionList()
  // }


  async getQuestionList() {
    try {
      if (this.activeIndex !== this.selfIndex)
        return


      this.dialog.open() //打开提示框
      if (this.isRefreshing) {
        this.page = 1
      }
      if (this.isLoadingMore) {
        this.page++
      }
      this.op = `questionBankType=10&type=${this.qid}&page=${this.page}&sort=${this.params.sort}`
      if (this.Project) this.op = `questionBankType=10&type=${this.qid}&page=${this.page}&sort=${this.isort}`
      const res = await Request.get<QuestionItem>('question/list?' + this.op)
      if (this.isLoadingMore) {
        this.questionList.push(...res.data.rows!)
      } else {
        this.questionList = res.data.rows!
      }
      // //由于第一次触底 把值赋予list
      // if (this.page == 1) this.questionList = res.data.rows!
      // //第二次及以后触底 this.list.push->
      // else if (this.page > 1 && res.data.pageTotal! > this.page) {
      //   this.questionList.push(...res.data.rows!)
      // }
      AppStorage.setOrCreate('qlist', this.questionList)
      //  关闭刷新
      this.isRefreshing = false
      this.isLoadingMore = false
      this.dialog.close() //关闭提示框
      promptAction.showToast({
        message: JSON.stringify(this.op)
      })

      // if (this.isLoadingMore && res.data.pageTotal! > this.page)
      //   this.page++

      // if (this.isLoadingMore && res.data.pageTotal! > this.page) {
      //   this.questionList.push(...res.data.rows!)
      //
      // } else {
      //   this.questionList = res.data.rows!
      // }


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
          // ForEach([1, 2, 3, 4, 5, 6], (item: number) => {
          //   ListItem() {
          //     QuestionItemComp({
          //       item: {
          //         id: '1',
          //         stem: '请总结一下Vue2中生命周期函数有哪些' + item,
          //         difficulty: 3,
          //         likeCount: 10,
          //         views: 20,
          //         readFlag: 1
          //       } as QuestionItemRow
          //     })
          //       .padding({ left: 10, right: 10 })
          //   }
          // })

          ForEach(this.questionList, (item: QuestionItemRow) => {
            ListItem() {
              QuestionItemComp({ item })
                .padding({ left: 10, right: 10 })
            }
            .onClick(() => {
              router.pushUrl({
                url: 'pages/QuestionDetailPage',
                params: { id: item.id }
              })
            })
          })
        }
        //上拉获取更多
        .onReachEnd(() => {
          // this.isLoadingMore = true
          clearTimeout(this.timeoutId)
          this.timeoutId = setTimeout(() => {
            this.isLoadingMore = true
            this.getQuestionList()
          }, 500)
        })
      }
      .onRefreshing(() => {
        this.isRefreshing = true
        // this.page = 1 // 刷新拉到第一页
        this.getQuestionList()

      }) //刷新 直到列表生成后 结束刷新

    }
  }
}