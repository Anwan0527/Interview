import fs from '@ohos.file.fs';
import http from '@ohos.net.http';

export interface iYunResponse {
  score: number // 评测总分
  usertext: string // 评测单词
  phonetic: string // 正确音标
  integrity: number // 录入语音的完整度
  pronunciation: number // 录入语音的标准度
  fluency: number // 录入语音的流利度
}


export class AudioAiTestServices {
  static async Audio_Ai_Test(wordEn: string, file: fs.File) {
    //  1. 定义http
    const httpReqeust = http.createHttp()
    let url = 'http://edu.hivoice.cn:8085/eval/pcm'

    // 2. 请求接口
    let res = await httpReqeust.request(url, {
      method: http.RequestMethod.POST,
      header: {
        "session-id": Date.now().toString(),
        "appkey": "izyr3jrjumsalbcqbtyktlasdf2begp53e5x4xirey4@2a24e11b24082992sdfd2b2bbf43dcfa65c",
        "Wrap-Create-Time": true,
        'Content-Type': 'multipart/form-data'
      },
      expectDataType: http.HttpDataType.OBJECT,
      multiFormDataList: [
        {
          name: 'text',
          contentType: 'text/plain',
          data: wordEn
        },
        {
          name: 'mode',
          contentType: 'text/plain',
          data: 'D'  // 返回当前语音文件的音素和音素评分，完整度，流利度，标准
        },
        {
          name: 'voice',
          contentType: 'application/octet-stream', // 二进制流数据
          filePath: file.path
        }
      ]
    })

    //   3. 获取语音评测接口的响应结果
    // AlertDialog.show({ message: JSON.stringify(res.result,null,2) })
    let resData = {
      score: res.result['EngineResult']['lines'][0]['score'],
      usertext: res.result['EngineResult']['lines'][0]['usertext'],
      phonetic: res.result['EngineResult']['lines'][0]['words'][1]['phonetic'],
      integrity: res.result['EngineResult']['lines'][0]['integrity'],
      pronunciation: res.result['EngineResult']['lines'][0]['pronunciation'],
      fluency: res.result['EngineResult']['lines'][0]['fluency']
    } as iYunResponse

    return resData
  }
}