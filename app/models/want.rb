class Want < Ownership
  def self.ranking
    # クラスメソッド。Want.rankingみたいにクラス自体から呼び出す
    self.group(:item_id).order("count_item_id DESC").limit(10).count(:item_id)
  end
end
