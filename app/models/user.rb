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
    has_many :followings, through: :relationships, source: :follow #relationshipという中間テーブルを通じて、そのfollow_id列を参照する。
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user #reverses_of_relationshipという中間テーブルを通じ、user_id列を参照
    #ここから課題↓
    has_many :favorites # foreign_key: 'user_id'省略　自分がお気に入りのMicropostへの参照
    has_many :myfavorites, through: :favorites, source: :micropost #favoritesという中間テーブルを通じて、micropost_id列を参照
    has_many :famous_for_user, class_name: 'Favorite', foreign_key: 'Micropost_id' #そのMicropostをお気に入りに登録しているUserへの参 class_nameはFavorite？？
    has_many :famousfor,through: :famous_for_user, source: :user #user.famousforでそのMicropostをお気に入りにしているUser達を取得
    
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
    
    def feed_microposts
        Micropost.where(user_id: self.following_ids + [self.id])
        #following_idsはUserモデルのhas_many :followings,...によって自動生成されるメソッド。UserがフォローしているUserのidの配列を取得
        #self.idもデータ型を合わせるために[self.id]と配列に変換して追加
    end
    
    def add2favorite(target_post)
        self.favorites.find_or_create_by(micropost_id: target_post.id)
        #binding.pry
        #favoritesテーブルのmicropost_id列からtarget_post_idに一致するレコードを取得。見つかればインスタンスを返す
        #見つからなければ、お気に入り関係を作成保存
    end
    
    def rm_favorite(target_post)
        favorite = self.favorites.find_by(micropost_id: target_post.id)
        favorite.destroy if favorite #favoriteに登録されていれば、削除する
    end
    
    def myfavorite?(target_post)
        self.myfavorites.include?(target_post)
        #自分のお気に入りを確認し、target_postが含まれていればtrueを返す
    end
    
end
