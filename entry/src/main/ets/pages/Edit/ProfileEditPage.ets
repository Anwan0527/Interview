import { promptAction } from '@kit.ArkUI'
import { User, UserModel } from '../../models/UserModel'
import { picker } from '@kit.CoreFileKit'
import fs from '@ohos.file.fs'
import request from '@ohos.request'
import { TOKEN_KEY } from '../../common/constants/token_key'
import { Logger } from '../../common/utils/Logger'
import { Request } from '../../common/utils/request'
import emitter from '@ohos.events.emitter'
import { LoadingDialog } from '../../common/components/LoadingDialog'

PersistentStorage.PersistProp(TOKEN_KEY, "")

@Entry
@Component
struct ProfileEditPage {
  @StorageProp('topHeight') topHeight: number = 0
  @StorageLink('user') currentUser: UserModel = {} as User
  URI: string = ''
  @State message: string = '完成0%'
  // 定义一个对话框实例
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: this.message }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async pickerAvatar() {
    //实例化参考对象
    const options = new picker.PhotoSelectOptions()
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE
    options.maxSelectNumber = 1
    //实例化选择器对象
    const pickerView = new picker.PhotoViewPicker()
    //调用
    let res = await pickerView.select(options)

    // 用户取消选择
    if (res.photoUris.length == 0) {
      promptAction.showToast({
        message: "用户取消照片选择"
      })
      return
    }
    this.URI = res.photoUris[0]
    this.uploadAvatar()
  }

  async uploadAvatar() {
    let ext = 'jpg'
    let fileName = Date.now().toString()
    let cacheDir = getContext().cacheDir
    let fullPath = cacheDir + '/' + fileName + '.' + ext
    let fullFileName = fileName + '.' + ext
    let file = fs.openSync(this.URI, fs.OpenMode.READ_ONLY)
    fs.copyFileSync(file.fd, fullPath)
    // promptAction.showToast({
    //   message: '图片拷贝成功'
    // })
    //上传图片
    this.dialog.open()
    let uploadFilePath = `internal://cache/${fullFileName}`
    let uploador = await request.uploadFile(getContext(), {
      method: 'POST',
      url: 'https://api-harmony-teach.itheima.net/hm/userInfo/avatar',
      header: {
        "Content-Type": "multipart/form-data",
        "Authorization": `Bearer ${this.currentUser.token}`
      },
      // name：指的是接口中的body中的参数名称，不能写错一定要和接口保持一致
      // uri:指的是应用程序缓存中的图片
      //filename：文件名称
      // type：文件类型，也就是扩展名
      files: [{ name: 'file', uri: uploadFilePath, filename: fullFileName, type: ext }],
      data: [] // 因为本接口除了上传文件之外，无需接收其他文本数据，所以空着即可
    })

    uploador.on('progress', (uploadSize, totalSize) => {
      //  这个回调函数是随着文件的上传会被不间断的触发执行，每次的uploadSize的值会增加，但是totalSize永远都是当前上传图片的大小
      //   所以我们可以通过判断 uploadSize === totalSize 表示上传完成，我们就可以做完成后端 逻辑处理
      let parcentStr = ((uploadSize / totalSize) * 100).toFixed(0).toString()
      Logger.info('上传:', parcentStr)
      emitter.emit({ eventId: 0 }, {
        data: {
          msg: '完成:' + parcentStr + "%"
        }
      })
      if (uploadSize === totalSize) {
        // AlertDialog.show({ message: '图片上传完成' })
        this.ReflshUserData()
        this.dialog.close()
      }
      //   由于此函数会被多次调用，所以我们可以在这个函数中计算处当前上传的进度百分比
    })
    //  监听上传失败的事件
    uploador.on('fail', (err) => {
      AlertDialog.show({ message: JSON.stringify(err) })
      this.dialog.close()
    })

  }

  async ReflshUserData() {
    let res = await Request.get<UserModel>('userInfo')
    this.currentUser.avatar = res.data.avatar
  }

  build() {
    Navigation() {
      Stack() {
        List() {
          ListItem() {
            Row() {
              Text('头像')
              Image(this.currentUser.avatar || $rawfile('avatar.png'))
                .width((40))
                .width((40))
                .borderRadius((40))
                .border({ width: 0.5, color: '#e4e4e4' })
                .onClick(() => {
                  // 选择头像并上传this.pickerAvatar()
                  this.pickerAvatar()
                })
            }.width('100%').height((60)).justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('昵称')
              TextInput({ text: this.currentUser.nickName || '昵称' })
                .textAlign(TextAlign.End)
                .layoutWeight(1)
                .padding(0)
                .height((60))
                .backgroundColor(Color.Transparent)
                .borderRadius(0)
                .onSubmit(() => {
                  // 修改昵称 this.updateNickName()

                })
            }.width('100%').height(60).justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('100%')
        .padding({ left: (45), right: (45), top: (15), bottom: (15) })
        .divider({ strokeWidth: 0.5, color: '#f5f5f5' })

      }.width('100%')
      .height('100%')
    }
    .padding({
      top: this.topHeight
    })
    .title('完善个人信息')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .linearGradient({
      colors: [['#FFB071', 0], ['#f3f4f5', 0.3], ['#f3f4f5', 1]]
    })
  }
}