/** 用户登陆 */
export interface UserLogin {
  /** 密码 */
  password: string;

  /** 用户名 */
  username: string;

}
export class UserLoginModel implements UserLogin {
  password: string = ''
  username: string = ''

  constructor(model: UserLogin) {
    this.password = model.password
    this.username = model.username
  }
}
