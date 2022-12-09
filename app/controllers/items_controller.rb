class ItemsController < ApplicationController
  def create
    @list = List.find(params[:list_id])
    item = @list.items.new(list_params)
    if item.save
      redirect_to @list
    end
  end

  def update
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])
    @item.toggle!(:completed)
    # list = List.find(params[:list_id])
    # item = list.items.find(params[:id])
    # item.toggle!(:completed)
    # respond_to do |format|
    #   format.turbo_stream do
    #     response = turbo_stream.replace "item_#{item.id}" do
    #       view_context.render(Lists::ItemComponent.new(list: list, item: item))
    #     end
    #     render turbo_stream: response
    #   end
    # end
  end

  private

  def list_params
    params.require(:item).permit(:name)
  end
end