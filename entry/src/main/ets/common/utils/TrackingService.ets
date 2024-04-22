import { TimeList } from '../../models/TimeListModel'
import { Request } from './request'
import { promptAction } from '@kit.ArkUI'

export class TrackingService {
  timelist: TimeList = {
    questionId: "0",
    endTime: 0,
    startTime: 0
  }
  timelistArr: TimeList[] = []

  setStartTime() {
    this.timelist.startTime = Date.now()
  }

  setEndTime() {
    this.timelist.endTime = Date.now()
  }

  setQuestionId(questid: string) {
    this.timelist.questionId = questid
  }

  save() {
    this.timelistArr.push(this.timelist)
    if (this.timelistArr.length >= 20) {
      Request.post<string>('time/tracking', this.timelistArr as TimeList[])
      this.timelistArr = []
      promptAction.showToast({
        message: '数据上报'
      })
    }
  }
}

export const trackingService = new TrackingService()