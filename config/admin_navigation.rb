SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Mazer::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.active_leaf_class = 'active'

  navigation.items do |primary|
    primary.item  :dashboard, t('admin.dashboard'), admin_root_path,  { icon: Icon::DASHBOARD, highlights_on: /admin$/ }
    primary.item :actors, t('ecosystem'), admin_actors_path, { icon: Icon::ACTOR } if can?(:read, Actor)
    primary.item :projects, Project.model_name.human(count: 2), admin_projects_path, { icon: Icon::PROJECT } if can?(:read, Project)
    primary.item :materials, Material.model_name.human(count: 2), admin_materials_path, { icon: Icon::MATERIAL } if can?(:read, Material) && (!current_user.visitor? || current_user.material_ids.any?)
    primary.item :technics, Technic.model_name.human(count: 2), admin_technics_path, { icon: Icon::TECHNIC } if can?(:read, Technic) && (!current_user.visitor? || current_user.technic_ids.any?)
    primary.item :pages, Page.model_name.human(count: 2), admin_pages_path, { icon: Icon::PAGE } if can?(:read, Page)
    primary.item :definitions, Definition.model_name.human(count: 2), admin_definitions_path, { icon: Icon::DEFINITION } if can?(:read, Definition)
    primary.item :comments, t('admin.comments.title'), pending_admin_comments_path, { icon: Icon::COMMENT, highlights_on: /admin\/comments/ } if can?(:update, User::Comment)
    primary.item :regions, Region.model_name.human(count: 2), admin_regions_path, { icon: Icon::REGION } if can?(:read, Region)
    primary.item :users, User.model_name.human(count: 2), admin_users_path, { icon: Icon::USER } if can?(:read, User)
    primary.item :subscriptions, Subscription.model_name.human(count: 2), admin_subscriptions_path, { icon: Icon::SUBSCRIPTION } if can?(:read, Subscription)
    primary.item :structure, t('admin.structure.title'), nil, { icon: Icon::STRUCTURE } do |secondary|
      Structure::Item::ABOUT_CLASSES.each do |about_class|
        label = about_class == 'Actor' ? t('ecosystem') : about_class.model_name.human(count: 2)
        secondary.item about_class.to_s, label, admin_structure_items_path(about_class: about_class)
      end
    end if can?(:edit, Structure::Item)
    primary.item :products, Product.model_name.human(count: 2), admin_products_path, { icon: Icon::PRODUCT } if can?(:manage, Product)
    primary.item :analytics, 'Analytics', admin_analytics_path, { icon: Icon::ANALYTICS } if ENV["APPLICATION_ENV"] == "production" && can?(:read, :analytics)
  end
end
