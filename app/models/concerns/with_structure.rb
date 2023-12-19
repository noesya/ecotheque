module WithStructure
  extend ActiveSupport::Concern

  def items
    @items ||= Structure::Item.where(about_class: self.class.to_s).order(:position)
  end

  # {"19e17124-64af-4c55-aaec-c1edbb0fa8c9"=>"test", "0acedf80-25b6-44b3-ae6a-dcd8d1db4993"=>"test"}
  def items=(hash)
    hash.each do |id, data|
      item = Structure::Item.find(id)
      value = value_for(item)
      value.text = data
      value.save
    end
  end

  def value_for(item)
    item.values.where(about: self).first_or_create
  end
end