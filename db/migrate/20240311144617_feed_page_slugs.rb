class FeedPageSlugs < ActiveRecord::Migration[7.1]
  def change
    Page.find_each do |page|
      page.slug = page.path
      page.save
    end
  end
end
