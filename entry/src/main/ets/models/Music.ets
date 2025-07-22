export interface songItemType {
  img: string
  name: string
  author: string
  src: string
  id: string
  tag?: string
}

export interface recommendCardType {
  icon?: Resource
  title: string
  subtitle: string
  tag?: string
  img: string
  canPlay?: boolean
  isPlay?: boolean
}

export interface recommendListType {
  img: string
  title: string
  count: string
}

export interface recommendDailyType {
  img: string
  title: string
  type: string
  song: string
  bottom: string
}

export interface favoriteListType {
  name: string
  nickName: string
  avatar: ResourceStr
  songs: songItemType[]
}

export interface momentListType {
  author: string
  avatar: string
  content: string
  comment: string
  song: songItemType
}

export interface paihangListType {
  img: string
  title1: string
  title2: string
  count: string
  song1: string
  author1: string
  song2: string
  author2: string
  song3: string
  author3: string
}

export class SongItemTypeModel implements songItemType {
  img: string = ''
  name: string = ''
  author: string = ''
  src: string = ''
  id: string = ''

  constructor(model: songItemType) {
    this.img = model.img
    this.name = model.name
    this.author = model.author
    this.src = model.src
    this.id = model.id
  }
}

export class RecommendListTypeModel implements recommendListType {
  img: string = ''
  title: string = ''
  count: string = ''

  constructor(model: recommendListType) {
    this.img = model.img
    this.title = model.title
    this.count = model.count
  }
}

export class RecommendDailyTypeModel implements recommendDailyType {
  img: string = ''
  title: string = ''
  type: string = ''
  song: string = ''
  bottom: string = ''

  constructor(model: recommendDailyType) {
    this.img = model.img
    this.title = model.title
    this.type = model.type
    this.bottom = model.bottom
  }
}

export class FavoriteListTypeModel implements favoriteListType {
  name: string = ''
  nickName: string = ''
  avatar: ResourceStr = ''
  songs: songItemType[] = []

  constructor(model: favoriteListType) {
    this.name = model.name
    this.nickName = model.nickName
    this.avatar = model.avatar
    this.songs = model.songs
  }
}

export class MomentListTypeModel implements momentListType {
  author: string = ''
  avatar: string = ''
  content: string = ''
  comment: string = ''
  song: songItemType = new SongItemTypeModel({} as songItemType)

  constructor(model: momentListType) {
    this.author = model.author
    this.avatar = model.avatar
    this.content = model.content
    this.comment = model.comment
    this.song = model.song
  }
}

export class PaihangListTypeModel implements paihangListType {
  img: string = ''
  title1: string = ''
  title2: string = ''
  count: string = ''
  song1: string = ''
  author1: string = ''
  song2: string = ''
  author2: string = ''
  song3: string = ''
  author3: string = ''

  constructor(model: paihangListType) {
    this.img = model.img
    this.title1 = model.title1
    this.title2 = model.title2
    this.count = model.count
    this.song1 = model.song1
    this.author1 = model.author1
    this.song2 = model.song2
    this.author2 = model.author2
    this.song3 = model.song3
    this.author3 = model.author3
  }
}