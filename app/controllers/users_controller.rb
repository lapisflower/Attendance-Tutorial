class UsersController < ApplicationController
 before_action :set_user, only: [:show, :edit, :update, :destroy]
 # editとupdateアクションが実行される直前にlogged_in_userメソッドが実行される。
 before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
 #アクセスしたユーザーが現在ログインしているユーザーであるか確認.
 before_action :correct_user, only: [:edit, :update]
 before_action :admin_user, only: :destroy
 
 
 # すべてのユーザー一覧ページ
 # すべてのユーザーを代入した複数形のためインスタンス変数は@users となる。
 def index
  @users = User.paginate(page: params[:page])
 end
 
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
     log_in @user
     flash[:success] = '新規作成に成功しました。'
   # ↓　redirect_to user_url(@user)を略せる。
     redirect_to @user
  else
   render :new
  end
 end
 
 def edit
 end
 
 # ユーザー情報を更新した後のページのアクション↓
 def update
   if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
   else
      render :edit
   end
 end
 
 def destroy
  @user.destroy
  flash[:success] = "#{@user.name}のデータを削除しました。"
  redirect_to users_url
 end
 
 private
 
 # (user_params)と↓のコードを記述することでStrong Parametersを用いることができる。
  def user_params
   params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end  
  
  
  
 
 # beforeフィルター
 
 def set_user
  @user = User.find(params[:id])
 end
 
 #ログイン済みのユーザーか確認する。logged_in?ヘルパーメソッド活用。 
  def logged_in_user
   unless logged_in?
   store_location
   flash[:danger] = "ログインしてください。"
   redirect_to login_url
   end
  end
  
  def correct_user
   @user = User.find(params[:id])
   redirect_to(root_url) unless current_user?(@user)
  end
  
  def admin_user
   redirect_to root_url unless current_user.admin?
  end
end
