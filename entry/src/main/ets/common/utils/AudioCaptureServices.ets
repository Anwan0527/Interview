import { audio } from '@kit.AudioKit'
import fs from '@ohos.file.fs';
import { Logger } from './Logger';

export class AudioCaptureServices {
  static currentCapturer: audio.AudioCapturer = Object()
  static isrunning: boolean = false // 用来标记当前是否录音
  //初始化
  static async init() {
    //创建录制音频对象
    try {
      const caputure = await audio.createAudioCapturer({
        streamInfo: {
          samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000, // 采样率 16K
          channels: audio.AudioChannel.CHANNEL_1, // 声道数 1
          sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE, //音频采样深度
          encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW //音频编码格式：PCM
        },
        capturerInfo: {
          source: audio.SourceType.SOURCE_TYPE_VOICE_COMMUNICATION, // 语音通话场景的音频源
          capturerFlags: 0
        }
      })
      // 2. 将音频录制对象赋值给类的全局静态变量
      AudioCaptureServices.currentCapturer = caputure
    } catch (err) {
      Logger.error('初始化录音对象错误:', JSON.stringify(err))
    }

  }

  //   2.0 开始录音 - > 将录音数据写入到文件.wav
  static async start(file: fs.File) {
    // 开始录音
    try {
      await AudioCaptureServices.currentCapturer.start()

      // :收集录音数据写入到具体的文件 (.wav)
      let bufferSize = AudioCaptureServices.currentCapturer.getBufferSizeSync()
      let offSet = 0
      while (AudioCaptureServices.isrunning) {
        //从录音对象中读取bufferSize长度数据
        let bufferArr = await AudioCaptureServices.currentCapturer.read(bufferSize, true)
        //bufferArr数据写入wav文件中去
        fs.writeSync(file.fd, bufferArr, {
          offset: offSet * bufferSize,
          length: bufferSize
        })
        offSet++

      }
    } catch (err) {
      Logger.error('录音异常', JSON.stringify(err))
    }
  }

  //3.0停止录音
  static async stop() {
    try {
      AudioCaptureServices.isrunning = false // 停止写数据
      setTimeout(async () => {
        await AudioCaptureServices.currentCapturer.stop()
      }, 100)
    } catch (err) {
      Logger.error('停止录音异常', JSON.stringify(err))
      AudioCaptureServices.isrunning = false // 停止写数据
    }

  }
}