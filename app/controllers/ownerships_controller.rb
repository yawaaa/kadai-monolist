class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])
    
    unless @item.persisted?
      # @itemが保存されていなかったら先に@itemを保存
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)
      
      @item = Item.new(read(results.first))
      @item.save
      # ここで@item.idが絶対存在するようになる
    end
    
    # want関係として保存
    if params[:type] == "Want"
      current_user.want(@item)
      flash[:success] = "商品を" + params[:type] + "しました"
    elsif params[:type] == "Have"
      # current_user.have(@item)
      flash[:success] = "商品を" + params[:type] + "しました"
    end
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    if params[:type] == "Want"
      current_user.unwant(@item)
      flash[:success] = "商品の Want を解除しました。"
    elsif params[:type] == "Have"
      # current_user.donthave(@item)
      flash[:success] = "商品の Have を解除しました。"
    end
    
    redirect_back(fallback_location: root_path)
  end
end
