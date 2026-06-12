class PlaylistItemData {
  icon: string = ''
  title: string = ''
  subtitle: string = ''
  rightText: string = ''
  rightIcon: string = ''
  badge: string = ''
  hasNewBadge: boolean = false
}

@Component
struct MusicSection {
  subTabIndex: number = 0
  private playlistItems: PlaylistItemData[] = [
    { icon: 'heart_fill', title: '我喜欢的音乐', subtitle: '0首', rightText: '心动模式', rightIcon: 'heart_mode', badge: '', hasNewBadge: false },
    { icon: 'chart', title: '听歌排行', subtitle: '累计听歌2首', rightText: '不置顶', rightIcon: 'pin', badge: '', hasNewBadge: false },
    { icon: 'ic_add', title: '新建歌单', subtitle: '', rightText: '', rightIcon: '', badge: '', hasNewBadge: true },
    { icon: 'import', title: '导入外部歌单', subtitle: '轻松导入其他APP里的歌单', rightText: '', rightIcon: '', badge: '', hasNewBadge: false }
  ]

  @Builder
  PlaylistRow(item: PlaylistItemData) {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Image($r('app.media.' + item.icon))
          .width(50)
          .height(50)
          .fillColor('#CDCDCD')
      }
      .width(50)
      .height(50)
      .backgroundColor('#2A2A2A')
      .borderRadius(8)
      .alignContent(Alignment.Center)

      Column({ space: 4 }) {
        Row({ space: 6 }) {
          Text(item.title)
            .fontSize(16)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Medium)
          if (item.hasNewBadge) {
            Text('NEW')
              .fontSize(10)
              .fontColor('#FFFFFF')
              .backgroundColor('#C20C0C')
              .borderRadius(4)
              .padding({ left: 5, right: 5, top: 2, bottom: 2 })
              .fontWeight(FontWeight.Bold)
          }
        }
        if (item.subtitle) {
          Text(item.subtitle)
            .fontSize(12)
            .fontColor('#666666')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({ left: 12 })

      if (item.rightText) {
        if (item.rightIcon === 'heart_mode') {
          Row({ space: 4 }) {
            Text('♡')
              .fontSize(14)
              .fontColor('#999999')
            Text(item.rightText)
              .fontSize(13)
              .fontColor('#999999')
          }
          .padding({ left: 14, right: 14, top: 6, bottom: 6 })
          .border({ width: 1, color: '#333333', radius: 16 })
        } else if (item.rightIcon === 'pin') {
          Text(item.rightText)
            .fontSize(13)
            .fontColor('#999999')
        }
      }
    }
    .width('100%')
    .height(72)
    .alignItems(VerticalAlign.Center)
    .padding({ top: 8, bottom: 8 })
  }

  build() {
    Column() {
      List({ space: 0 }) {
        ForEach(this.playlistItems, (item: PlaylistItemData) => {
          ListItem() {
            this.PlaylistRow(item)
          }
        })
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default MusicSection
