class Relationship < ApplicationRecord
  belongs_to :user #,class_name: 'User'  省略できる
  belongs_to :follow, class_name: 'User' #followは命名規則変更によりUserクラスを参照する
end
