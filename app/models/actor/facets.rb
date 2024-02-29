class Actor::Facets < FacetedSearch::FacetsWithItems
  def initialize(params)
    super
    @model = Actor.published.ordered
    @class_name = 'Actor'
    filter_with_text :name, {
      title: 'Nom'
    }
    add_facets_for_items
  end
end