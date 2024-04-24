import fs from '@ohos.file.fs';

export class FileServices {
  static async CreateFile() {
    //   结合fs.openSync方法 来读写或者创建一个.wav文件
    // 1. 获取当前应用程序的缓存目录
    let cacheDir = getContext().cacheDir

    // 2. 准备一个文件名，扩展名为.wav
    let fileName = Date.now() + '.wav'

    // 3.以创建，读写的权限方式来打开这个文件
    let fullFilePath = cacheDir + '/' + fileName
    let file = fs.openSync(fullFilePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE)
    return file
  }
}