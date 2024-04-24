import fs from '@ohos.file.fs'
import { promptAction } from '@kit.ArkUI';
import { AudioCaptureServices } from '../../common/utils/AudioCaptureServices';
import { FileServices } from '../../common/utils/FileService';
import { AudioAiTestServices, iYunResponse } from '../../common/utils/AudioAiTestServices';


@CustomDialog
export struct WordTestDialog {
  controller: CustomDialogController
  @State scanSize: number = 1
  @State isshowbow: boolean = false
  wordEn: string = ''
  file: fs.File = {} as fs.File
  @State
  aiTestResult: iYunResponse = {
    score: 0, // 评测总分
    usertext: this.wordEn, // 评测单词
    phonetic: "['entrɪ]", // 正确音标
    integrity: 0, // 录入语音的完整度
    pronunciation: 0, // 录入语音的标准度
    fluency: 0 // 录入语音的流利度
  }

  build() {
    Column({ space: 10 }) {
      Column({ space: 20 }) {
        Text('单词朗读评测')
          .width('100%')
          .textAlign(TextAlign.Start)

        Column() {
          Column() {
            Text('本次得分')
              .fontSize(20)

            Text(this.aiTestResult.score?.toFixed(0) + '分')
              .fontSize(26)
          }
          .foregroundColor(Color.White)
          .width(100)
          .height(50)
          .margin({ right: 10, top: 10 })
        }
        .width(150)
        .height(80)
        .borderRadius(25)
        .backgroundColor(Color.Orange)

        Text() {
          Span('单词：')
          Span(this.aiTestResult.usertext)
        }
        .fontSize(30)

        // Text('正确读音：'+this.aiTestResult.phonetic)
        //   .fontSize(16)

        Row() {
          Text('语音完整度')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Text(this.aiTestResult.integrity?.toFixed(0))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor(this.aiTestResult.integrity < 60 ? Color.Red : Color.Blue)
        }
        .padding(10)
        .width('90%')
        .backgroundColor('rgba(0,0,0,0.03)')

        Row() {
          Text('语音标准度')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Text(this.aiTestResult.pronunciation?.toFixed(0))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor(this.aiTestResult.pronunciation < 60 ? Color.Red : Color.Blue)
        }
        .padding(10)
        .width('90%')
        .backgroundColor('rgba(0,0,0,0.03)')

        Row() {
          Text('语音流利度')
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Text(this.aiTestResult.fluency?.toFixed(0))
            .layoutWeight(1)
            .textAlign(TextAlign.Center)
            .fontColor(this.aiTestResult.fluency < 60 ? Color.Red : Color.Blue)
        }
        .padding(10)
        .width('90%')
        .backgroundColor('rgba(0,0,0,0.03)')

      }
      .width('100%')

      Blank()

      if (this.isshowbow) {
        Image($r('app.media.bolang1'))
          .height(20)
          .width('60%')
          .margin({ bottom: 50 })
      }
      Image($r('app.media.ic_public_audio'))
        .fillColor(Color.Blue)
        .width(50)
        .aspectRatio(1)
        .draggable(false)
        .animation({
          duration: 300
        })
        .scale({ x: this.scanSize, y: this.scanSize })
        .onTouch(async (event: TouchEvent) => {

          if (event.type === TouchType.Down) {
            this.scanSize = 2
            this.isshowbow = true
            // 开始录音
            promptAction.showToast({ message: '开始录音' })
            //初始化
            await AudioCaptureServices.init()
            //调用start方法录音
            let file = await FileServices.CreateFile()
            await AudioCaptureServices.start(file)
          }

          if (event.type === TouchType.Up) {
            this.scanSize = 1
            this.isshowbow = false
            // 停止录音
            promptAction.showToast({ message: '停止录音' })
            // 上传音频获取AI测评结果
            await AudioCaptureServices.stop()

            // 上传录音文件到ai平台进行评测
            //   注意：延迟提交
            setTimeout(async () => {
              // 调用接口
              let resdata = await AudioAiTestServices.Audio_Ai_Test(this.wordEn, this.file)
              this.aiTestResult = resdata
            }, 500)

          }
        })
    }
    .height(600)
    .width('100%')
    .borderRadius(25)
    .backgroundColor('rgb(247,248,248)')
    .padding(20)
  }
}