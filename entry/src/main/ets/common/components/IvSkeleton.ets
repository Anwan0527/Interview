@Preview
@Component
export struct IvSkeleton {
  widthValue: number | string = 100
  heightValue: number | string = 20
  @State translateValue: string = "-100%"

  build() {
    Stack() {
      Text()
        .backgroundColor($r('app.color.common_gray_bg'))
        .height('100%')
        .width('100%')

      Text()
        .height('100%')
        .width('100%')
        .translate({ x: this.translateValue })
        .linearGradient({
          angle: 45,
          colors: [
            ['rgba(255,255,255,0)', 0],
            ['rgba(255,255,255,1)', 0.5],
            ['rgba(255,255,255,0)', 0]
          ]
        })
        .animation({ duration: 1500, iterations: -1 })
        .onAppear(() => {
          this.translateValue = '100%'
        })

    }
    .height(this.heightValue)
    .width(this.widthValue)
  }
}