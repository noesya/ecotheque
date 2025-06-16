class Project::Facets < FacetedSearch::FacetsWithItems
  def initialize(params, **options)
    super(params)
    @model = options[:model].published
    @region = options[:region]
    @class_name = 'Project'
    add_facets_for_order
    filter_with_text :name, {
      title: Project.human_attribute_name('name'),
      placeholder: I18n.t('search.search_in_name')
    }
    add_facets_for_items
    add_facets_for_regions unless @region.present?
    filter_with_list :criterions, {
      title: I18n.t('projects.brezet_wheel.title'),
      source: Project::Criterion.ordered_by_step,
      habtm: true
    }
  end
end
