//负责对整个项目的日志输出封装
import { hilog } from '@kit.PerformanceAnalysisKit'

const DOMAIN: number = 0x0000
const TAG: string = "mytag"
const FORMAT: string = '%{public}s%{public}s' //想写几个参数就加几个参数

//定义一个Logger类,定义四个静态方法
export class Logger {
  static debug(...args: string[]) {
    hilog.debug(DOMAIN, TAG, FORMAT, ...args)
  }

  static info(...args: string[]) {
    hilog.info(DOMAIN, TAG, FORMAT, ...args)
  }

  static warn(...args: string[]) {
    hilog.warn(DOMAIN, TAG, FORMAT, ...args)
  }

  static error(...args: string[]) {
    hilog.error(DOMAIN, TAG, FORMAT, ...args)
  }
}

