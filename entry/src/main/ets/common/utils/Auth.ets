//封装数据,存储USER_KEY
import { UserModel } from '../../models/UserModel'
import { router } from '@kit.ArkUI'

const USER_KEY = 'USER_KEY'
const PASS_LIST = ['pages/LoginPage']

export class Auth {
  static initLocalUser() {
    PersistentStorage.persistProp(USER_KEY, '{}') // 初始化KEY值为空
  }

  static setUser(user: UserModel) {
    AppStorage.set(USER_KEY, JSON.stringify(user)) //存储USER_key
  }

  static getUser() {
    const str = AppStorage.get<string>(USER_KEY) || '{}'
    return JSON.parse(str) as UserModel //获取USER_Key
  }

  static delUser() {
    AppStorage.set(USER_KEY, '{}') //删除USER_Key 用于退出软件
  }

  //需要登陆页面使用
  static pushUrl(options: router.RouterOptions) {
    const user = Auth.getUser()
    if (!PASS_LIST.includes(options.url) && !user.token) {
      return router.pushUrl({
        url: "/pages/Login/LoginPage".slice(1),
        params: {
          // ...options.params,//todo 报错
          return_url: options.url
        }
      })
    }
    return router.pushUrl(options)
  }
}