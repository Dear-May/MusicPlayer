@Entry
@Component
struct RecommendView {
  build() {
    Column() {
      Text('笔记')
        .fontSize(20)
        .fontColor($r('sys.color.white'))
    }
    .width('100%')
    .height('100%')

  }
}

export default RecommendView;