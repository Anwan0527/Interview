/** 返回数据 */
export interface iHdUserModel {
  /** 用户头像地址 */
  avatar: string | null;

  /** 连续打卡天数 */
  clockinNumbers: number;

  /** 用户id */
  id: string;

  /** 昵称 */
  nickName: string;

  /** token过期后，刷新token使用 */
  refreshToken: string;

  /** 分享加密串 */
  shareInfo: string;

  /** 后续交互使用的token */
  token: string;

  /** 学习时长，单位s */
  totalTime: number;

  /** 昵称 */
  username: string | null;
}
export class iHdUserModelModel implements iHdUserModel {
  avatar: string | null = null
  clockinNumbers: number = 0
  id: string = ''
  nickName: string = ''
  refreshToken: string = ''
  shareInfo: string = ''
  token: string = ''
  totalTime: number = 0
  username: string | null = null

  constructor(model: iHdUserModel) {
    this.avatar = model.avatar
    this.clockinNumbers = model.clockinNumbers
    this.id = model.id
    this.nickName = model.nickName
    this.refreshToken = model.refreshToken
    this.shareInfo = model.shareInfo
    this.token = model.token
    this.totalTime = model.totalTime
    this.username = model.username
  }
}
