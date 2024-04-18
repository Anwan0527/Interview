import { HdResponse } from '../../models/HttpResponseModel'
import http from '@ohos.net.http'
import { promptAction, router } from '@kit.ArkUI'
import { BusinessError } from '@kit.BasicServicesKit'
import { TOKEN_KEY } from '../constants/token_key'

type HdParams = Record<string, number | string | boolean>

class HdHttp {
  private baseUrl: string

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl || ''
  }

  get<T>(url: string, extraData?: Object): Promise<HdResponse<T>> {
    const httpInstance = http.createHttp()
    url = this.baseUrl + url

    if (extraData) {
      const paramsList = Object.keys(extraData).map(key => `${key}=${(extraData as HdParams)[key]}`)
      const paramsString = paramsList.join('&')
      url += '?' + paramsString
    }

    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json'
      }
    , expectDataType: http.HttpDataType.OBJECT
    }


    if (AppStorage.get(TOKEN_KEY) && options.header) {
      options.header['Authorization'] = 'Bearer ' + AppStorage.get(TOKEN_KEY)
    }

    return httpInstance.request(url, options).then(res => {
      if (res.result) {
        const result = res.result as HdResponse<T>
        if (result.code === 401) {
          promptAction.showToast({ message: 'token失效' })
          AppStorage.set(TOKEN_KEY, '')
          router.pushUrl({
            url: 'pages/Login/LoginPage'
          }, router.RouterMode.Single)
        }
        return result
      }
      return Promise.reject(res.result)
    })
      .catch((err: BusinessError) => {
        promptAction.showToast({ message: err.message || '网络错误' })
        return Promise.reject(err)
      })
  }

  post<T>(url: string, extraData?: Object): Promise<HdResponse<T>> {
    const httpInstance = http.createHttp()

    url = this.baseUrl + url

    const options: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json'
      }
    , expectDataType: http.HttpDataType.OBJECT
    }

    if (extraData) {
      options.extraData = extraData
    }


    if (AppStorage.get(TOKEN_KEY) && options.header) {
      options.header['Authorization'] = 'Bearer ' + AppStorage.get(TOKEN_KEY)
    }

    return httpInstance.request(url, options).then(res => {
      if (res.result) {
        const result = res.result as HdResponse<T>
        if (result.code === 401) {
          AppStorage.set(TOKEN_KEY, '')
          router.pushUrl({
            url: 'pages/Login/LoginPage'
          }, router.RouterMode.Single)
        }
        return result
      }
      return Promise.reject(res.responseCode)
    }).catch((err: BusinessError) => {
      promptAction.showToast({ message: err.message || '网络错误' })
      return Promise.reject(err)
    })
  }
}

export const Request = new HdHttp('https://api-harmony-teach.itheima.net/hm/')