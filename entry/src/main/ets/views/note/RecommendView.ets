import { CommonConstants } from "../../constants/CommonConstants";
import { SectionsWaterFlowDataSource } from "../../models/viewmodel/SectionsWaterFlowDataSource";

// 文章Item组件
@Reusable
struct NoteCardItem {
  @State item: number = 0;

  aboutToReuse(params: Record<string, number>) {
    this.item = params.item;
  }

  build() {
    RelativeContainer() {
      Image($rawfile(`sections/${this.item % 4}.jpg`))
        .objectFit(ImageFit.Cover)
        .width(CommonConstants.FULL_WIDTH)
        .layoutWeight(1)
        .borderRadius(8)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id('image1')

      Stack() {
      }
      .linearGradient({
        angle: 0,
        colors: [['#80000000', 0.0],
          ['#03000000', 1.0]]
      })
      .width(CommonConstants.FULL_WIDTH)
      .height(32)
      .borderRadius(8)
      .hitTestBehavior(HitTestMode.None)
      .alignRules({
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .id('mask1')

      Text('NO. ' + (this.item + 1))
        .fontSize(12)
        .fontColor(Color.White)
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .margin({
          left: 8,
          bottom: 4
        })
        .id('text1')
    }
    .width(CommonConstants.FULL_WIDTH)
    .borderRadius(8)
    .backgroundColor(Color.Gray)
  }
}

@Preview
@Component
struct RecommendView {
  @State isRefreshing: boolean = false;
  @State currentItem: number = -1;
  @State minSize: number = CommonConstants.FLOW_ITEM_MIN_HEIGHT;
  @State maxSize: number = CommonConstants.FLOW_ITEM_MAX_HEIGHT;
  scroller: Scroller = new Scroller();
  dataSource: SectionsWaterFlowDataSource = new SectionsWaterFlowDataSource();
  private itemHeightArray: number[] = [];
  @State sections: WaterFlowSections = new WaterFlowSections();
  sectionMargin: Margin = {
    top: 8,
    left: 0,
    bottom: 0,
    right: 0
  };
  twoColumnSection: SectionOptions = {
    itemsCount: 2,
    crossCount: 2,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: () => {
      return CommonConstants.SECTION2_ITEM_SIZE;
    }
  };
  dataSection: SectionOptions = {
    itemsCount: 20,
    crossCount: 2,
    margin: this.sectionMargin,
    onGetItemMainSizeByIndex: (index: number) => {
      return this.itemHeightArray[index % CommonConstants.REFRESH_COUNT];
    }
  };

  // 刷新数据源和章节配置
  private refresh() {
    this.currentItem = -1;

    setTimeout(() => {
      // 清空现有数据并添加新的随机数据
      this.dataSource.dataArray = [];
      let value = Math.floor(Math.random() * CommonConstants.REFRESH_COUNT);
      for (let i = 0; i < CommonConstants.REFRESH_COUNT; i++) {
        this.dataSource.dataArray.push(i + value);
        this.dataSource.notifyDataAdd(i);
      }

      // 只更新dataSection的配置，保持双列布局
      let dataCount = this.dataSource.totalCount();
      this.dataSection.itemsCount = dataCount;
      this.dataSection.crossCount = 2;
      this.sections.update(0, this.dataSection);
      this.isRefreshing = false;
    }, CommonConstants.REFRESH_TIMEOUT);
  }

  // 加载更多数据
  private loadMore(last: number) {
    setTimeout(() => {
      let totalCount = this.dataSource.totalCount();
      // 判断是否需要加载更多数据
      if (last + CommonConstants.LOAD_MORE_COUNT >= totalCount) {
        // 添加更多数据项
        for (let i = 0; i < CommonConstants.LOAD_MORE_COUNT; i++) {
          this.dataSource.addLastItem();
        }
        // 更新数据区域的项目数量
        this.dataSection.itemsCount += CommonConstants.LOAD_MORE_COUNT;
        // 更新sections中的数据区域
        this.sections.update(2, this.dataSection);
      }
    }, CommonConstants.LOAD_MORE_TIMEOUT);
  }

  // 获取随机大小值
  private getSize() {
    let ret = Math.floor(Math.random() * this.maxSize);
    return (ret > this.minSize ? ret : this.minSize);
  }

  // 设置项目大小数组
  private setItemSizeArray() {
    // 循环生成随机高度值并添加到数组中
    for (let i = 0; i < CommonConstants.REFRESH_COUNT; i++) {
      this.itemHeightArray.push(this.getSize());
    }
  }

  //初始化分段配置
  private initSections() {
    let sectionOptions: SectionOptions[] = [];
    let dataCount = this.dataSource.totalCount();

    // 使用双列布局section，并设置itemsCount为全部数据量
    this.dataSection.itemsCount = dataCount;
    this.dataSection.crossCount = 2;
    sectionOptions.push(this.dataSection);

    // 将生成的分段配置插入到sections数组的开头
    this.sections.splice(0, 0, sectionOptions);
  }

  //从数据源中移除指定项，并更新相关章节的计数信息
  private removeItem(item: number): void {
    // 查找并删除数据源中的项目
    let index = this.dataSource.indexOf(item);
    this.dataSource.deleteItem(index);

    // 获取所有章节配置
    const sections: Array<SectionOptions> = this.sections.values();
    let newSection: SectionOptions;
    let tmpIndex = 0;
    let sectionIndex = 0;

    // 查找包含该item的章节索引
    for (let i = 0; i < sections.length; i++) {
      tmpIndex += sections[i].itemsCount;
      if (index < tmpIndex) {
        sectionIndex = i;
        break;
      }
    }

    // 更新找到的章节信息
    newSection = sections[sectionIndex];
    newSection.itemsCount -= 1;

    // 如果crossCount超过当前itemsCount，则调整crossCount
    if (newSection.crossCount && newSection.crossCount > newSection.itemsCount) {
      newSection.crossCount = newSection.itemsCount;
    }

    // 更新章节配置
    this.sections.update(sectionIndex, newSection);
  }

  aboutToAppear() {
    this.setItemSizeArray();
    this.initSections();
  }

  @Builder
  headerRefresh() {
    Column() {
      LoadingProgress()
        .color(Color.Black)
        .opacity(0.6)
        .width('36vp')
        .height('36vp')
    }
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column({ space: 0 }) {
      Refresh({ refreshing: $$this.isRefreshing, builder: this.headerRefresh() }) {
        WaterFlow({ scroller: this.scroller, sections: this.sections }) {
          LazyForEach(this.dataSource, (item: number) => {
            FlowItem() {
              Stack() {
                Row() {
                  Button('delete')
                    .fontColor(Color.Red)
                    .backgroundColor(Color.White)
                    .onClick(() => {
                      this.getUIContext().animateTo({ duration: CommonConstants.DELETE_ANIMATION_TIME }, () => {
                        this.removeItem(item);
                      });
                    })
                }
                .width(CommonConstants.FULL_WIDTH)
                .height(CommonConstants.FULL_HEIGHT)
                .borderRadius(8)
                .justifyContent(FlexAlign.Center)
                .zIndex(1)
                .visibility(this.currentItem === item ? Visibility.Visible : Visibility.Hidden)
                .backgroundColor($r('sys.color.mask_fourth'))

                NoteCardItem({ item: item })
              }
            }
            .transition({ type: TransitionType.Delete, opacity: 0 })
            .priorityGesture(LongPressGesture()
              .onAction(() => {
                this.currentItem = item;
              }))
            .width(CommonConstants.FULL_WIDTH)
            .borderRadius(8)
            .backgroundColor(Color.Gray)
          }, (item: string) => item)
        }
        .cachedCount(CommonConstants.CACHED_COUNT)
        .columnsGap(8)
        .rowsGap(8)
        .padding({ bottom: '48vp' })
        .width(CommonConstants.FULL_WIDTH)
        .height(CommonConstants.FULL_HEIGHT)
        .layoutWeight(1)
        .onScrollIndex((_first: number, last: number) => {
          this.loadMore(last);
        })
      }
      .refreshOffset(CommonConstants.REFRESH_OFFSET)
      .onRefreshing(() => {
        this.refresh();
      })
    }
  }
}

export default RecommendView;