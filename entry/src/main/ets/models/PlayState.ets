/*
 *   Copyright (c) 2025 Huawei Device Co., Ltd.
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */

// 传输数据的结构
import { songItemType } from './Music';

export class PlayStateType {
  img: string = '' // 音乐封面
  name: string = '' // 音乐名称
  author: string = '' // 作者
  src: string = '' // 当前播放链接
  playIndex: number = 0 // 当前在播放列表中的播放索引
  time: number = 0 // 播放时间
  duration: number = 0 // 音乐的播放时长
  isPlay: boolean = false // 是否正在播放
  playMode: 'auto' | 'repeat' | 'random' = 'auto' // 播放模式
  playList: songItemType[] = [] // 当前的播放列表
  cacheImg?: string // 缓存图片地址
}
