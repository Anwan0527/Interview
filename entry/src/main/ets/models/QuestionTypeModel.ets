export interface QuestionType {
  /** 项目分类类别描述 */
  describeInfo: string | null;
  /** 是否展示最新图标标识0不展示1展示 */
  displayNewestFlag: number;
  /** 项目类的分类图标（知识点的不返回） */
  icon: string | null;
  /** 主键id */
  id: number;
  /** 分类名称 */
  name: string;
  /** 项目类返回标签信息 */
  tags: Tag[] | null;

}

export interface Tag {
  /** 边框颜色 */
  borderColor: string;
  /** 标签颜色 */
  nameColor: string;
  /** 标签名称 */
  tagName: string;

}
export class QuestionTypeModel implements QuestionType {
  describeInfo: string | null = null
  displayNewestFlag: number = 0
  icon: string | null = null
  id: number = 0
  name: string = ''
  tags: Tag[] | null = null

  constructor(model: QuestionType) {
    this.describeInfo = model.describeInfo
    this.displayNewestFlag = model.displayNewestFlag
    this.icon = model.icon
    this.id = model.id
    this.name = model.name
    this.tags = model.tags
  }
}
export class TagModel implements Tag {
  borderColor: string = ''
  nameColor: string = ''
  tagName: string = ''

  constructor(model: Tag) {
    this.borderColor = model.borderColor
    this.nameColor = model.nameColor
    this.tagName = model.tagName
  }
}
