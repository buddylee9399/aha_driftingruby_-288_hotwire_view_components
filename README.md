# Drifting ruby - Using view components
- https://www.driftingruby.com/episodes/hotwire-viewcomponents

- gem 'view_component', '~> 2.78'
- bundle
- restart server
- rails g scaffold lists name
- rails g model item list:belongs_to name completed:boolean
- update migration

```
t.boolean :completed, default: false
```

- rails db:migrate
- update list.rb

```
has_many :items
```

- rails g component lists/new_item
- rails g component lists/new_item list_id --force (to override the previous files)
- update lists show page

```
<%= render Lists::NewItemComponent.new(list_id: @list.id) %>
```

- update components/lists/new_item .html

```
<%= form_with model: [list, Item.new] do |form| %>
  <h2>New Item</h2>
  <%= form.text_field :name %>
  <%= form.submit %>
<% end %>
```

- update components/lists/new_item

```
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

```

- update routes

```
  resources :lists do
    resources :items, only: [:create, :update]
  end
```

- create the controllers/items_controller.rb

```
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
```

- rails g component lists/item list item
- update components/lists/item_component html

```
<style>
  .item_component__completed {
    text-decoration: line-through;
  }

  .item_component__button_inline {
    display: inline-block;
  }

  .item_component__button_link {
    background: none;
    border: none;
    padding: 0;
    color: #0275d8;
    text-decoration: underline;
    cursor: pointer;
  }
</style>
<%= turbo_frame_tag dom_id(item) do %>
  <%= content_tag :div, class: class_names(item_component__completed: item.completed?) do %>
    <%= item.name %>
    <% text = item.completed? ? 'make active' : 'complete' %>
    <div class='item_component__button_inline'>
      <%= button_to text, [list, item], method: :patch, class: 'item_component__button_link' %>
    </div>
  <% end %>
<% end %>
```
- update components/lists/item_component.rb

```

class Lists::ItemComponent < ViewComponent::Base
  include Turbo::FramesHelper

  attr_accessor :list, :item
  def initialize(list:, item:)
    @list = list
    @item = item
  end

end
```

- update lists/show

```
<% @list.items.each do |item| %>
  <%= render Lists::ItemComponent.new(list: @list, item: item) %>
<% end %>
```

- create the folder views/items
- create file items/update.turbo_stream.erb
```
<%= turbo_stream.replace dom_id(@item) do %>
  <%= render(Lists::ItemComponent.new(list: @list, item: @item)) %>
<% end %>
```
- refresh and test out, it worked

## THE END