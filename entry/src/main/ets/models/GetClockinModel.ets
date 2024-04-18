/** 返回数据 */
export interface GetClockin {
  /** 连续签到天数 */
  clockinNumbers: number;

  /** 签到信息 */
  clockins: ClockinMes[];

  /** 当天是否签到 */
  flag: boolean;

  /** 累计签到天数 */
  totalClockinNumber: number;

}

export interface ClockinMes {
  /** 签到时间 */
  createdAt: string;
  id: string;

}
export class GetClockinModel implements GetClockin {
  clockinNumbers: number = 0
  clockins: ClockinMes[] = []
  flag: boolean = false
  totalClockinNumber: number = 0

  constructor(model: GetClockin) {
    this.clockinNumbers = model.clockinNumbers
    this.clockins = model.clockins
    this.flag = model.flag
    this.totalClockinNumber = model.totalClockinNumber
  }
}
export class ClockinMesModel implements ClockinMes {
  createdAt: string = ''
  id: string = ''

  constructor(model: ClockinMes) {
    this.createdAt = model.createdAt
    this.id = model.id
  }
}
