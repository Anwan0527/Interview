export interface TimeList {
  /** 结束时间（毫秒） */
  endTime: number;

  /** 试题id */
  questionId: string;

  /** 开始时间(毫秒) */
  startTime: number;

}
export class TimeListModel implements TimeList {
  endTime: number = 0
  questionId: string = ''
  startTime: number = 0

  constructor(model: TimeList) {
    this.endTime = model.endTime
    this.questionId = model.questionId
    this.startTime = model.startTime
  }
}
