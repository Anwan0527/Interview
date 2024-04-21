//负责对用户搜索条件进行首选项存取操作
import preferences from '@ohos.data.preferences'

const pintance = preferences.getPreferencesSync(getContext(), { name: 'keywordSearch' })
const KEY = 'keyword'

export class SearchQueryStore {
  //存储数据
  static async saveData(data: string) {
    let arr = await pintance.get(KEY, []) as Array<string>
    if (arr.indexOf(data) === -1) {
      arr.push(data)
    }
    await pintance.put(KEY, arr)
    await pintance.flush() //持久化
  }

  //获取数据
  static async getData() {
    return await pintance.get(KEY, []) as Array<string>
  }

  //删除数据-单个删除
  static async delByKeyWord(keyword: string) {
    let arr = await pintance.get(KEY, []) as Array<string>
    let index = arr.findIndex(item => item === keyword)
    arr.splice(index, 1)
    await pintance.put(KEY, arr)
    await pintance.flush() //持久化
  }

  //删除数据-全部删除
  static async delAll() {
    await pintance.put(KEY, [])
    await pintance.flush() //持久化
  }
}