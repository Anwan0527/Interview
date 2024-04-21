import { promptAction, router } from '@kit.ArkUI'
import { SearchQueryStore } from '../common/utils/SearchQueryStore'
import { SearchResultListComp } from '../views/search/SearchResultListComp'

interface iSearchItemParams {
  text: string
  isShowDel: boolean
  delCallBack: () => void
}

interface iRouterParams {
  keywordTxt: string
}

@Entry
@Component
struct SearchPage {
  qtype: number = 0 // 0：全部类型
  @State isShow: boolean = false
  @State txtContent: string = ''
  @State searchQueryList: string[] = ['html', 'css', 'vue', '鸿蒙']
  @State isSearch: boolean = false //是否打开搜索组件
  @StorageProp('topHeight') topHeight: number = 0

  aboutToAppear(): void {
    let routerparams = router.getParams() as iRouterParams
    this.txtContent = routerparams.keywordTxt
    this.isSearch = true
    this.loadData()
  }

  async loadData() {
    const res = await SearchQueryStore.getData()
    this.searchQueryList = res
  }

  @Builder
  SearchItem(params: iSearchItemParams) {
    Row() {
      Text(params.text)
        .onClick(() => {
          if (!params.isShowDel) {
            this.txtContent = params.text
            this.isSearch = true
          }
        })
      if (params.isShowDel) {
        Text('x')
          .width(10)
          .margin({ left: 15 })
          .fontColor('rgba(0,0,0,0.3)')
          .onClick(() => {
            params.delCallBack()
          })
      }
      else {
        Text('')
          .width(10)
          .margin({ left: 15 })
          .fontColor('rgba(0,0,0,0.3)')
      }
    }
    .height(40)
    .width('auto')
    .padding({ top: 10, bottom: 10, left: 15, right: 15 })
    .borderRadius(20)
    .margin({ left: 5, right: 5, top: 10 })
    .backgroundColor('rgba(0,0,0,0.04)')
  }

  build() {
    Navigation() {
      // 搜索区
      Row() {
        Stack() {
          TextInput({ placeholder: '请输入关键字', text: this.txtContent })
            .margin({ left: 15, right: 15 })
            .textAlign(TextAlign.Center)
            .onChange((value) => {
              this.txtContent = value
            })
            .onSubmit(async () => {
              // 打开查询数据组件
              this.isSearch = true
              //存数据
              SearchQueryStore.saveData(this.txtContent)
              //取数据
              this.loadData()
            })

          Image($r('app.media.ic_common_search1'))
            .height(15)
            .aspectRatio(1)
            .translate({ x: -60 })
            .visibility(this.txtContent.length > 0 ? Visibility.Hidden :
            Visibility.Visible)
        }
        .layoutWeight(1)

        Text('取消')
          .width(50)
          .padding({ right: 15 })
          .fontWeight(500)
          .onClick(() => {
            // 打开查询数据组件
            this.isSearch = false
          })

      }
      .margin({ bottom: 20 })

      if (!this.isSearch) {
        // 搜索条件区域
        Column({ space: 20 }) {

          // 搜索记录->isShow控制不同元素的显示
          Column() {
            //  操作区
            Row() {
              Text('搜索记录')
                .fontSize(20)
                .fontWeight(600)
                .layoutWeight(1)
                .margin({ left: 20 })

              if (!this.isShow) {
                Image($r('app.media.ic_common_delete'))
                  .height(20)
                  .aspectRatio(1)
                  .fillColor(Color.Gray)
                  .margin({ right: 20 })
                  .onClick(() => {
                    this.isShow = true
                  })
              } else {
                Text() {
                  Span('全部删除')
                    .onClick(async () => {
                      promptAction.showToast({ message: '全部删除' })
                      SearchQueryStore.delAll()
                      this.loadData()
                    })
                  Span(' | ')
                  Span('完成')
                    .onClick(() => {
                      this.isShow = false
                    })
                }
                .fontColor(Color.Gray)
                .margin({ right: 20 })
              }
            }

            // 记录列表
          }

          //  搜索记录
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.searchQueryList, (item: string) => {
              this.SearchItem({
                text: item, isShowDel: this.isShow,
                delCallBack: async () => {
                  SearchQueryStore.delByKeyWord(item)
                  this.loadData()
                }
              })
            })
          }
        }
      }

      // 搜索列表组件
      if (this.isSearch) {
        SearchResultListComp({ keyword: this.txtContent })

      }
    }
    .title('刷个面试题')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .padding({ top: this.topHeight })
  }
}