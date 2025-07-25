@Entry
@Component
struct SearchPage {
  @State searchText: string = '';

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '搜索歌曲、歌手、专辑', text: this.searchText })
          .width('85%')
          .height(40)
          .fontSize(16)
          .placeholderColor('#666')
          .backgroundColor('#333')
          .borderRadius(20)
          .padding({ left: 16 })
          .onChange((value: string) => {
            this.searchText = value;
          })

        Blank()

        Text('取消')
          .fontSize(16)
          .fontColor('#999')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 48 })
      .backgroundColor('#0e0d11')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      Column() {
        Text('搜索你喜欢的音乐')
          .fontSize(14)
          .fontColor('#666')
          .margin({ top: '60%' })
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function SearchBuilder(): void {
  SearchPage();
}