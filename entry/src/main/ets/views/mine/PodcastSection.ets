@Component
struct PodcastSection {
  subTabIndex: number = 0

  @Builder
  EmptyContent(category: string) {
    Column() {
      Text('暂无' + category + '内容')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 60 })
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Start)
  }

  build() {
    Column() {
      if (this.subTabIndex === 0) {
        this.EmptyContent('全部')
      } else if (this.subTabIndex === 1) {
        this.EmptyContent('播客')
      } else {
        this.EmptyContent('有声书')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default PodcastSection
