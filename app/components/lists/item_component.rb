
class Lists::ItemComponent < ViewComponent::Base
  include Turbo::FramesHelper

  attr_accessor :list, :item
  def initialize(list:, item:)
    @list = list
    @item = item
  end

end