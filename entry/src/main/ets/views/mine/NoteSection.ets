@Component
struct NoteSection {
  build() {
    Column() {
      Text('暂无笔记')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 60 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121212')
    .justifyContent(FlexAlign.Start)
  }
}

export default NoteSection
