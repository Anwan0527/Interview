// 用户信息持久化，获取用户，设置用户，删除用户以及用户访问页面控制
export interface User {
  id: string
  username: string
  avatar: string
  refreshToken: string
  token: string
  totalTime: number | null
  nickName: string | null
  clockinNumbers: number | null
}


export class UserModel implements User {
  id: string = ''
  username: string = ''
  avatar: string = ''
  refreshToken: string = ''
  token: string = ''
  totalTime: number | null = null
  nickName: string | null = null
  clockinNumbers: number | null = null

  constructor(model: User) {
    this.id = model.id
    this.username = model.username
    this.avatar = model.avatar
    this.refreshToken = model.refreshToken
    this.token = model.token
    this.totalTime = model.totalTime
    this.nickName = model.nickName
    this.clockinNumbers = model.clockinNumbers
  }
}
