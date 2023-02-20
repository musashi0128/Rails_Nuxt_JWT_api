require "validator/email_validator"

class User < ApplicationRecord
  # gem bcryptを使うメリット
    # 1.passwordを暗号化する
    # 2.password_digest => passwordとして扱える
    # 3.password_confirmation => passwordの一致確認
    # 4.一致のバリデーションの追加
    # 5.authenticate()
    # 6.72文字まで使える
    # 7.User.create() => 入力必須のバリデーションが追加
  has_secure_password
  before_validation :downcase_email

  # validates
  validates :name, presence: true,
                   length: {
                    maximum: 30,
                    allow_blank: true
                   }

  validates :email, presence: true,
                    email: { allow_blank: true }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                       length: {
                        minimum: 8,
                        allow_blank: true
                       },
                       format: {
                         with: VALID_PASSWORD_REGEX,
                         message: :invalid_password,
                         allow_blank: true
                       },
                       allow_nil: true
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    # 自分以外のUserを取得する
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  private
   # emailの小文字か
   def downcase_email
    self.email.downcase! if email
   end
end
