class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  # before_save { self.email = self.email.downcase }でも可。#
  #　downcaseメソッドを使って小文字に変換してくれる　#
  
  validates :name, presence: true, length: { maximum: 50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  #　渡された文字列のハッシュを返す。
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムなトークンを返す。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためハッシュ化したトークンをデータベースに記憶する。
  # selfを記述することで仮想のremember_token属性にUser.new_tokenで生成した「ハッシュ化されたトークン情報」を代入。
  # そしてupdate_attributeメソッドでトークンダイジェストを更新。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #トークンがダイジェストと一致すればtrueを返す。
  def authenticated?(remember_token)
    # ダイジェストが存在しない場合はfalseを返して終了する。
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # 永続的セッションを終了する準備↓
  def forget
    update_attribute(:remember_digest, nil)
  end
end