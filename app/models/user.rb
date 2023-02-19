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

  # validates
  validates :name, presence: true,
                   length: {
                    maximum: 30,
                    allow_blank: true
                   }
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
end
