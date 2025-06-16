class FacetedSearch::FacetsWithItems < FacetedSearch::Facets
  attr_reader :class_name

  protected

  def add_facets_for_items
    items.each do |item|
      add_facet ::FacetedSearch::Facets::Item, item.slug, { item: item }
    end
  end

  def add_facets_for_regions
    filter_with_list :regions, {
      title: Region.model_name.human(count: 2),
      source: Region.ordered,
      find_by: :slug,
      habtm: true
    }
  end

  def add_facets_for_order
    add_facet ::FacetedSearch::Facets::Order, :order_by, {
      title: "Trier par",
      source: [
        ["Ordre alphabétique", "name:asc"],
        ["Ordre alphabétique inversé", "name:desc"],
        ["Plus récents", "date:desc"],
        ["Plus anciens", "date:asc"]
      ]
    }
  end

  def items
    @items ||= Structure::Item.where(about_class: @class_name).with_options.ordered
  end
end
