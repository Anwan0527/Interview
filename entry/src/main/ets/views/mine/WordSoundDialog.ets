import { media } from '@kit.MediaKit'
import { request } from '@kit.BasicServicesKit'
import fs from '@ohos.file.fs'
import { Logger } from '../../common/utils/Logger'


@CustomDialog
export struct WordSoundDialog {
  controller: CustomDialogController
  wordEn: string = ''
  wordZh: string = ''
  @State
  isGreen: boolean = false
  timer: number = -1
  streamId: number = -1
  avplayer: media.AVPlayer = Object()

  async playMp3(url: string) {
    //创建对象
    const avPlayer = await media.createAVPlayer()
    this.avplayer = avPlayer
    //监听
    avPlayer.on("stateChange", (state) => {
      if (state == 'initialized') {
        //设置了播放源
        avPlayer.prepare()
      }
      if (state == 'prepared') {
        //已经准备
        avPlayer.loop = true //循环
        avPlayer.play()
      }
    })
    //设置播放源
    avPlayer.url = url
  }

  aboutToAppear() {
    this.playMp3('http://dict.youdao.com/dictvoice?audio=' + this.wordEn + '&type=1')
  }

  aboutToDisappear() {
    this.avplayer.pause()
    this.avplayer.stop()
  }

  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(this.wordEn)
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(500)
        Image($r('app.media.ic_public_sound'))
          .width(20)
          .aspectRatio(1)
          .fillColor(this.isGreen ? $r('app.color.common_green') : Color.White)
          .onAppear(() => {
            clearInterval(this.timer)
            this.timer = setInterval(() => {
              this.isGreen = !this.isGreen
            }, 500)
          })
          .onDisAppear(() => {
            clearInterval(this.timer)
            this.avplayer.pause()
            this.avplayer.stop()
          })
          .animation({ duration: 300 })
      }

      Text(this.wordZh)
        .fontColor(Color.White)
    }
    .constraintSize({ minWidth: 175 })
    .padding({ left: 16, right: 16 })
    .height(90)
    .borderRadius(45)
    .backgroundColor('#8f000000')
    .justifyContent(FlexAlign.Center)
  }
}