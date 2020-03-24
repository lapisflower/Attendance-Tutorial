class UsersController < ApplicationController
 
 def show
   @user = User.find(params[:id])
 end

 def new
  @user = User.new
 end
 
 # ユーザー登録ページ
 def create
   # (user_params)メソッドはUsersコントローラー内のみで実行される。
   # @user = User.newd(params[:id])と書くとRalis4.0以降はエラーになる。
   # セキュリティ強化の為。
  @user = User.new(user_params)
  if @user.save
    flash[:success] = '新規作成に成功しました。'
   # ↓　redirect_to user_url(@user)を略せる。
    redirect_to @user
  else
   render :new
  end
 end
 
 private
 
 # (user_params)と↓のコードを記述することでStrong Parametersを用いることができる。
  def user_params
   params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end  
end