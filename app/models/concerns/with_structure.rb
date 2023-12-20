module WithStructure
  extend ActiveSupport::Concern

  def items
    @items ||= Structure::Item.where(about_class: self.class.to_s).order(:position)
  end

  # {"19e17124-64af-4c55-aaec-c1edbb0fa8c9"=>"test", "0acedf80-25b6-44b3-ae6a-dcd8d1db4993"=>"test"}
  def items=(hash)
    hash.each do |id, data|
      item = Structure::Item.find(id)
      next if item.nil?
      item.save_value(self, data)
    end
  end

  def value_for(item)
    item.value_for(self)
  end

  def option_for(item)
    item.option_for(self)
  end

  def selected_option?(option)
    option.item.selected_option?(self, option)
  end
end
