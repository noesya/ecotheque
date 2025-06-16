Page.find_or_create_by(internal_identifier: 'home') do |page|
    page.name = 'Accueil'
    page.slug = 'accueil'
end
Page.find_or_create_by(internal_identifier: 'mentions-legales') do |page|
    page.name = 'Mentions légales'
    page.slug = 'mentions-legales'
end
Page.find_or_create_by(internal_identifier: 'cgu') do |page|
    page.name = "Conditions générales d'utilisation"
    page.slug = 'conditions-generales-d-utilisation'
end
Page.find_or_create_by(internal_identifier: 'contact') do |page|
    page.name = 'Contact'
    page.slug = 'contact'
end
Page.find_or_create_by(internal_identifier: 'boite-a-outils') do |page|
    page.name = 'Boite à outils'
    page.slug = 'boite-a-outils'
end
page_lab = Page.find_or_create_by(internal_identifier: 'le-lab') do |page|
    page.name = 'Le Lab'
    page.slug = 'le-lab'
end
Page.find_or_create_by(internal_identifier: 'l-association') do |page|
    page.name = "L'association"
    page.slug = 'l-association'
    page.parent = page_lab
    page.position = 1
end
Page.find_or_create_by(internal_identifier: 'donation') do |page|
    page.name = "Faire un don"
    page.slug = 'faire-un-don'
end