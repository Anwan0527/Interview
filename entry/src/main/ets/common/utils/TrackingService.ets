import { TimeList } from '../../models/TimeListModel'
import { Request } from './request'

export class TrackingService {
  timelist: Partial<TimeList> = {}

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
    Request.post<string>('time/tacking', [this.timelist])
  }
}