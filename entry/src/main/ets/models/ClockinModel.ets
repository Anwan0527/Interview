/** 返回数据 */
export interface Clockin {
  /** 头像 */
  avatar: string;

  /** 背景图片地址 */
  backgroudPicture: string;

  /** 连续打卡的天数 */
  clockinNumbers: number;

  /** 打卡总天数 */
  clockinTotal: number;

  /** 小程序二维码 */
  miniAppPicture: string;

  /** 昵称 */
  nickName: string;

}
export class ClockinModel implements Clockin {
  avatar: string = ''
  backgroudPicture: string = ''
  clockinNumbers: number = 0
  clockinTotal: number = 0
  miniAppPicture: string = ''
  nickName: string = ''

  constructor(model: Clockin) {
    this.avatar = model.avatar
    this.backgroudPicture = model.backgroudPicture
    this.clockinNumbers = model.clockinNumbers
    this.clockinTotal = model.clockinTotal
    this.miniAppPicture = model.miniAppPicture
    this.nickName = model.nickName
  }
}
