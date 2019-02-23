class ItemsController < ApplicationController
  before_action :require_user_logged_in

  def new
    @items = []
    
    @keyword = params[:keyword]
    if @keyword.present?
      results = RakutenWebService::Ichiba::Item.search({
        keyword: @keyword,
        imageFlag: 1,
        hits: 20,
      })
      

      
      results.each do |result| 
        # 扱いやすいようにItemとしてインスタンス作成する。（保存はしない）
        item = Item.find_or_initialize_by(read(result))
        # newにしないのは、item_idをunwantで利用するためにとっとくから
        @items << item
        
        # 今後want haveに追加されたときだけItemインスタンスを保存する
      end
    end
  end
  
  def show
    @item = Item.find(params[:id])
    @want_users = @item.want_users
    @have_users = @item.have_users
  end

end 
