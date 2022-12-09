# frozen_string_literal: true

class Lists::NewItemComponent < ViewComponent::Base
  def initialize(list_id:)
    @list_id = list_id
  end
  private

  def list
    List.find(@list_id)
  end
end
