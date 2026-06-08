# 网易云音乐 API 文档 (NeteaseCloudMusicApi)

> 基础路径: http://localhost:3000

> 所有接口为 GET 请求，返回 JSON 格式数据

---

## ArkTS 调用示例

由于此 API 是 HTTP 服务，在 ArkTS 中通过 @ohos.net.http 发起 HTTP 请求即可：

`
import http from '@ohos.net.http';

let httpRequest = http.createHttp();
httpRequest.request(
  'http://你的服务器IP:3000/search?keywords=周杰伦',
  { method: http.RequestMethod.GET },
  (err, data) => {
    if (!err) {
      const result = JSON.parse(data.result.toString());
      console.log(result.code); // 200
    }
  }
);
`

## 常用通用参数

| 参数 | 类型 | 说明 |
|---|---|---|
| cookie | string | 可选，传入登录后的 Cookie |
| noCookie | bool | 可选，设为 true 时不返回 Set-Cookie |

---

## 一、登录认证

### 1.1 手机号登录

`
GET /login/cellphone
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| phone | string | ✅ | 手机号 |
| password | string | ✅ | 密码 |
| countrycode | string | ❌ | 国家码，默认 86 |
| captcha | string | ❌ | 验证码（如启用） |

### 1.2 邮箱登录

`
GET /login
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| email | string | ✅ | 邮箱 |
| password | string | ✅ | 密码 |

### 1.3 二维码登录

获取 Key

`
GET /login/qr/key
`

生成二维码

`
GET /login/qr/create
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| key | string | ✅ | 上一步获取的 key |
| qrimg | bool | ❌ | 是否返回 base64 二维码图片 |
| platform | string | ❌ | pc / web，默认 pc |

检查扫码状态

`
GET /login/qr/check
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| key | string | ✅ | 上一步获取的 key |

### 1.4 刷新登录状态

`
GET /login/refresh
`

### 1.5 获取登录状态

`
GET /login/status
`

### 1.6 退出登录

`
GET /logout
`

### 1.7 匿名注册

`
GET /register/anonimous
`

### 1.8 手机号注册

`
GET /register/cellphone
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| phone | string | ✅ | 手机号 |
| password | string | ✅ | 密码 |
| captcha | string | ✅ | 验证码 |
| nickname | string | ✅ | 昵称 |
| countrycode | string | ❌ | 国家码，默认 86 |

### 1.9 发送验证码

`
GET /captcha/sent
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| phone | string | ✅ | 手机号 |

### 1.10 验证验证码

`
GET /captcha/verify
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| phone | string | ✅ | 手机号 |
| captcha | string | ✅ | 验证码 |

---

## 二、搜索

### 2.1 搜索

`
GET /search
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| keywords | string | ✅ | 搜索关键词 |
| type | number | ❌ | 1:单曲 10:专辑 100:歌手 1000:歌单 1002:用户 1004:MV 1006:歌词 1009:电台 1014:视频 2000:声音 |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 2.2 搜索建议

`
GET /search/suggest
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| keywords | string | ✅ | 关键词 |
| type | string | ❌ | mobile返回移动端数据 |

### 2.3 热搜列表

`
GET /search/hot
`

### 2.4 热搜详情

`
GET /search/hot/detail
`

### 2.5 默认搜索词

`
GET /search/default
`

### 2.6 多重匹配搜索

`
GET /search/multimatch
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| keywords | string | ✅ | 关键词 |

---

## 三、歌曲

### 3.1 歌曲详情

`
GET /song/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| ids | string | ✅ | 歌曲 ID，多个用 , 分隔 |

### 3.2 歌曲链接（播放地址）

`
GET /song/url
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | string | ✅ | 歌曲 ID，多个用 , 分隔 |
| br | number | ❌ | 码率: 999000(无损) 320000 192000 128000，默认999000 |

### 3.3 歌曲歌词

`
GET /lyric
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |

### 3.4 新歌词接口

`
GET /lyric/new
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |

### 3.5 检查歌曲可用性

`
GET /check/music
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |

### 3.6 点赞/取消点赞歌曲

`
GET /like
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |
| like | bool | ❌ | true 点赞，false 取消，默认true |

### 3.7 获取点赞列表

`
GET /likelist
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| uid | number | ✅ | 用户 ID |

### 3.8 相似歌曲

`
GET /simi/song
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |
| limit | number | ❌ | 默认50 |
| offset | number | ❌ | 偏移量 |

---

## 四、歌单

### 4.1 歌单详情

`
GET /playlist/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| s | number | ❌ | 收藏者数量，默认8 |

### 4.2 歌单内全部歌曲

`
GET /playlist/track/all
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| limit | number | ❌ | 每页数量，默认1000 |
| offset | number | ❌ | 偏移量，默认0 |

### 4.3 歌单动态信息

`
GET /playlist/detail/dynamic
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |

### 4.4 收藏/取消收藏歌单

`
GET /playlist/subscribe
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| t | number | ✅ | 1 收藏，2 取消收藏 |

### 4.5 歌单收藏者

`
GET /playlist/subscribers
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 4.6 热门歌单

`
GET /top/playlist
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| cat | string | ❌ | 分类，默认全部 |
| limit | number | ❌ | 默认50 |
| offset | number | ❌ | 默认0 |

### 4.7 精品歌单

`
GET /top/playlist/highquality
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| cat | string | ❌ | 分类，默认全部 |
| limit | number | ❌ | 默认50 |
| before | number | ❌ | 分页参数 |

### 4.8 创建歌单

`
GET /playlist/create
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| name | string | ✅ | 歌单名称 |
| privacy | number | ❌ | 0 公开，10 隐私 |

### 4.9 歌单添加歌曲

`
GET /playlist/track/add
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| pid | number | ✅ | 歌单 ID |
| ids | string | ✅ | 歌曲 ID，多个用 , 分隔 |

### 4.10 歌单删除歌曲

`
GET /playlist/track/delete
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| ids | string | ✅ | 歌曲 ID，多个用 , 分隔 |

### 4.11 删除歌单

`
GET /playlist/delete
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |

---

## 五、专辑

### 5.1 专辑详情

`
GET /album
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 专辑 ID |

### 5.2 新碟上架

`
GET /album/new
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |
| area | string | ❌ | ALL(全部) ZH(华语) EA(欧美) KR(韩国) JP(日本) |

### 5.3 收藏/取消收藏专辑

`
GET /album/sub
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 专辑 ID |
| t | number | ✅ | 1 收藏，2 取消 |

---

## 六、歌手

### 6.1 歌手详情

`
GET /artist/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |

### 6.2 歌手热门歌曲

`
GET /artists
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |

### 6.3 歌手专辑

`
GET /artist/album
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 6.4 歌手 MV

`
GET /artist/mv
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 6.5 歌手介绍

`
GET /artist/desc
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |

### 6.6 相似歌手

`
GET /simi/artist
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |

### 6.7 收藏/取消收藏歌手

`
GET /artist/sub
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌手 ID |
| t | number | ✅ | 1 收藏，2 取消 |

---

## 七、MV / 视频

### 7.1 MV 详情

`
GET /mv/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| mvid | number | ✅ | MV ID |

### 7.2 MV 播放地址

`
GET /mv/url
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | MV ID |
| r | number | ❌ | 分辨率，默认1080 |

### 7.3 全部 MV

`
GET /mv/all
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| area | string | ❌ | 地区: 全部 内地 港台 欧美 日本 韩国 |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 7.4 视频详情

`
GET /video/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 视频 ID |

### 7.5 视频播放地址

`
GET /video/url
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 视频 ID |
| res | number | ❌ | 分辨率 |

---

## 八、评论

### 8.1 发送/回复评论

`
GET /comment
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 资源 ID |
| type | number | ✅ | 0:歌曲 1:MV 2:歌单 3:专辑 4:电台 5:视频 6:动态 |
| t | number | ✅ | 1:发送 2:回复 |
| content | string | ✅ | 评论内容 |
| commentId | number | ❌ | 回复的评论 ID |

### 8.2 歌单评论

`
GET /comment/playlist
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌单 ID |
| limit | number | ❌ | 默认20 |
| offset | number | ❌ | 默认0 |

### 8.3 歌曲评论

`
GET /comment/music
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |
| limit | number | ❌ | 默认20 |
| offset | number | ❌ | 默认0 |

### 8.4 MV 评论

`
GET /comment/mv
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | MV ID |
| limit | number | ❌ | 默认20 |
| offset | number | ❌ | 默认0 |

### 8.5 专辑评论

`
GET /comment/album
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 专辑 ID |

### 8.6 热门评论

`
GET /comment/hot
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 资源 ID |
| type | number | ✅ | 0:歌曲 1:MV 2:歌单 3:专辑 4:电台 5:视频 |
| limit | number | ❌ | 默认20 |
| offset | number | ❌ | 默认0 |

### 8.7 评论点赞

`
GET /comment/like
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 资源 ID |
| type | number | ✅ | 0:歌曲 1:MV 2:歌单 3:专辑 4:电台 5:视频 |
| t | number | ✅ | 1 点赞 2 取消 |
| commentId | number | ✅ | 评论 ID |

---

## 九、用户

### 9.1 用户详情

`
GET /user/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| uid | number | ✅ | 用户 ID |

### 9.2 用户歌单

`
GET /user/playlist
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| uid | number | ✅ | 用户 ID |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 9.3 用户听歌排行

`
GET /user/record
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| uid | number | ✅ | 用户 ID |
| type | number | ❌ | 1:最近一周 0:所有时间 |

### 9.4 用户动态

`
GET /user/event
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| uid | number | ✅ | 用户 ID |
| limit | number | ❌ | 默认30 |
| lasttime | number | ❌ | 分页参数 |

### 9.5 关注/取消关注用户

`
GET /follow
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 用户 ID |
| t | number | ✅ | 1 关注 0 取消 |

### 9.6 获取用户账户信息

`
GET /user/account
`

### 9.7 用户等级

`
GET /user/level
`

### 9.8 用户云盘

`
GET /user/cloud
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

---

## 十、排行榜

### 10.1 所有排行榜

`
GET /toplist
`

### 10.2 排行榜详情

`
GET /toplist/detail
`

### 10.3 歌手榜

`
GET /toplist/artist
`

### 10.4 热门歌手

`
GET /top/artists
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认50 |
| offset | number | ❌ | 默认0 |

### 10.5 新歌速递

`
GET /top/song
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| type | number | ❌ | 0:全部 7:华语 96:欧美 8:日本 16:韩国 |

### 10.6 新碟排行榜

`
GET /top/album
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 10.7 MV 排行榜

`
GET /top/mv
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| area | string | ❌ | 地区 |
| limit | number | ❌ | 默认30 |

---

## 十一、推荐

### 11.1 每日推荐歌曲

`
GET /recommend/songs
`

### 11.2 每日推荐歌单

`
GET /recommend/resource
`

### 11.3 推荐歌单

`
GET /personalized
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 11.4 推荐新音乐

`
GET /personalized/newsong
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |

---

## 十二、私人 FM

### 12.1 私人 FM

`
GET /personal/fm
`

### 12.2 FM 垃圾歌曲

`
GET /fm/trash
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |

---

## 十三、电台

### 13.1 电台详情

`
GET /dj/detail
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| rid | number | ✅ | 电台 ID |

### 13.2 电台节目

`
GET /dj/program
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| rid | number | ✅ | 电台 ID |
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 13.3 热门电台

`
GET /dj/hot
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 13.4 电台推荐

`
GET /dj/recommend
`

### 13.5 订阅/取消订阅电台

`
GET /dj/sub
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| t | number | ✅ | 1 订阅 2 取消 |
| rid | number | ✅ | 电台 ID |

### 13.6 订阅电台列表

`
GET /dj/sublist
`

---

## 十四、首页

### 14.1 首页轮播图

`
GET /banner
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| type | number | ❌ | 0:pc 1:android 2:iphone 3:ipad |

---

## 十五、云盘

### 15.1 云盘数据

`
GET /cloud
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| limit | number | ❌ | 默认30 |
| offset | number | ❌ | 默认0 |

### 15.2 云盘删除

`
GET /cloud/del
`

| 参数 | 类型 | 必填 | 说明 |
|---|---|---|---|
| id | number | ✅ | 歌曲 ID |

---

## 十六、VIP

### 16.1 VIP 信息

`
GET /vip/info
`

### 16.2 VIP 任务

`
GET /vip/tasks
`

### 16.3 成长值

`
GET /vip/growthpoint
`

---

## 十七、云贝

### 17.1 云贝签到

`
GET /yunbei/sign
`

### 17.2 云贝信息

`
GET /yunbei/info
`

### 17.3 云贝推荐歌曲

`
GET /yunbei/rcmd/song
`

---

## 快速启动

在项目目录下执行：

`
cd D:\\Cache\\Html\\netease-api
node node_modules/NeteaseCloudMusicApi/app.js
`

服务启动在 http://localhost:3000

测试：

`
# 搜索
curl http://localhost:3000/search?keywords=周杰伦

# 获取歌曲播放地址
curl http://localhost:3000/song/url?id=186016

# 获取歌词
curl http://localhost:3000/lyric?id=186016
`

---

文档生成于 2026-06-06

