class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum:50 }
    validates :email, presence: true, length: { maximum:255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
        
    has_secure_password 
    # Rails標準のパスワード付きモデル
    
    has_many :microposts
    has_many :relationships #foreign_key: 'user_id'は命名規則により省略
    has_many :followings, through: :relationships, source: :follow #relationshipという中間テーブルを通じて、そのfollow列を参照する。
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user #reverses_of_relationshipという中間テーブルを通じ、user列を参照
    
    def follow(other_user) #他のユーザーをフォローするメソッド
        unless self == other_user #自分自身ではない事を確認
        #selfはUserのインスタンス(user.follow(other)を実行したときuserが代入される)
            self.relationships.find_or_create_by(follow_id: other_user.id)#Relationshipsテーブルのfollow_idカラムから other_user.idに一致するレコード取得
            #見つかればRelationshipモデルのインスタンスを返す
            #見つからなければフォロー関係を作成保存（create = build + save）
        end
    end
    
    def unfollow(other_user) #アンフォローするメソッド
        relationship = self.relationships.find_by(follow_id: other_user.id)#Relationshipsテーブルのfollwo_idカラムから other_user.idに一致するレコード取得
        relationship.destroy if relationship #上で取得したレコードを削除
        #if Relationshipが存在すれば、relationshipをdestroyする
    end
    
    def following?(other_user) #既にフォローしているかどうかを確認するメソッド
        self.followings.include?(other_user)
        #self.followingsによりフォローしているUser達を取得
        #include?(other_user)でother_userが含まれていないかを確認し、含まれているときはtrue
    end
    
end
