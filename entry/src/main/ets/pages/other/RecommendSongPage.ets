import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';

@Entry
@Component
struct RecommendSongPage {
  build() {
    Column() {
      Row() {
        Image($r('app.media.menu'))
          .width(24)
          .height(24)
          .rotate({ angle: 90 })
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Text('Recommend Songs')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column() {
          ForEach(songs, (item: songItemType) => {
            Row() {
              Image($r('app.media.image_1'))
                .width(60)
                .height(60)
                .borderRadius(8)

              Column({ space: 4 }) {
                Text(item.name)
                  .fontSize(16)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Medium)
                Text(item.author)
                  .fontSize(12)
                  .fontColor('#888')
              }
              .margin({ left: 12 })
              .layoutWeight(1)

              Button() {
                Text('Recommend')
                  .fontSize(12)
                  .fontColor(Color.White)
              }
              .backgroundColor('#ff4a4a')
              .borderRadius(12)
              .height(28)
              .padding({ left: 12, right: 12 })
              .onClick(() => {
                console.log('Recommended: ' + item.name);
              })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
          })
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function RecommendSongBuilder(): void {
  RecommendSongPage();
}
