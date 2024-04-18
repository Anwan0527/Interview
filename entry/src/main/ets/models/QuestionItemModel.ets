/** 报文数据 */
export interface QuestionItem {
  /** 总页数 */
  pageTotal: number | null;

  /** 数据集合 */
  rows: QuestionItemRow[] | null;

  /** 总数 */
  total: number | null;
}

export interface QuestionItemRow {
  /** 内容描述-面经有,试题列表没有 */
  content: string;

  /** 新增时间 */
  createdAt: string | null;

  /** 面经创建者头像 */
  creatorAvatar: string;

  /** 创建者名称 */
  creatorName: string;

  /** 难度，难度-面试题需要显示此字段，注：1-2星是简单，3-4星是一般，5星是困难 */
  difficulty: number | null;

  /** 题目id */
  id: string;

  /** 点赞数量 */
  likeCount: number;

  /** 已点赞1 未点赞0 */
  likeFlag: number;

  /** 场景教案场景，双元教案1、核心提炼2、随堂测试3、随堂练习4、每日作业 */
  planSceneName: PlanSceneName | null;

  /** 题号/面经的标题 */
  questionNo: string | null;

  /** 题型：1单选，2多选，3判断，5简答，6代码，7实操 */
  questionType: number | null;

  /** 是否已读标志，0未读1已读 */
  readFlag: number;

  /** 题干 */
  stem: string;

  /** 题干附件-面经列表的图片 */
  stemAttachmentId: string | null;

  /** 学科 */
  subjectName: string | null;

  /** 浏览量 */
  views: number;
}

/** 场景教案场景，双元教案1、核心提炼2、随堂测试3、随堂练习4、每日作业 */
export enum PlanSceneName {
  Empty = "",
  其他 = "其他",
  核心提炼 = "核心提炼",
  每日作业 = "每日作业",
  随堂测试 = "随堂测试",
  随堂练习 = "随堂练习",
}

export class QuestionItemModel implements QuestionItem {
  pageTotal: number | null = null
  rows: QuestionItemRow[] | null = null
  total: number | null = null

  constructor(model: QuestionItem) {
    this.pageTotal = model.pageTotal
    this.rows = model.rows
    this.total = model.total
  }
}

export class QuestionItemRowModel implements QuestionItemRow {
  content: string = ''
  createdAt: string | null = null
  creatorAvatar: string = ''
  creatorName: string = ''
  difficulty: number | null = null
  id: string = ''
  likeCount: number = 0
  likeFlag: number = 0
  planSceneName: PlanSceneName | null = null
  questionNo: string | null = null
  questionType: number | null = null
  readFlag: number = 0
  stem: string = ''
  stemAttachmentId: string | null = null
  subjectName: string | null = null
  views: number = 0

  constructor(model: QuestionItemRow) {
    this.content = model.content
    this.createdAt = model.createdAt
    this.creatorAvatar = model.creatorAvatar
    this.creatorName = model.creatorName
    this.difficulty = model.difficulty
    this.id = model.id
    this.likeCount = model.likeCount
    this.likeFlag = model.likeFlag
    this.planSceneName = model.planSceneName
    this.questionNo = model.questionNo
    this.questionType = model.questionType
    this.readFlag = model.readFlag
    this.stem = model.stem
    this.stemAttachmentId = model.stemAttachmentId
    this.subjectName = model.subjectName
    this.views = model.views
  }
}
