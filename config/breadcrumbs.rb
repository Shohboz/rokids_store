crumb :root do
  link "Каталог", store_path
end

crumb :products do
  link "Товары", products_path
end

crumb :product do |product|
  link product.title, product
  parent :products
end

crumb :category do |category|
  link category.title, store_path(:category => category.id)
end

crumb :store do |product|
	link product.title, product
	parent :category, product.categories.first if product.categories.first
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).