class FacetedSearch::FacetsWithItems < FacetedSearch::Facets

  protected

  def add_facets_for_items
    items.each do |item|
      add_facet ::FacetedSearch::Facets::Item, item.slug, { item: item }
    end
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
    @items ||= Structure::Item.where(about_class: @class_name ).with_options.ordered
  end
end
