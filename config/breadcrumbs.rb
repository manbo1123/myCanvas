crumb :root do
  link "Home", root_path
end

# マイページ
crumb :user do
  link "マイページ", user_path
  parent :root
end
# ユーザー編集ページ
crumb :user_edit do
  link "ユーザー情報の編集", edit_user_path
  parent :user
end

# キャンバス関連
  # キャンバス詳細ページ
  crumb :post do
    #link Post.find(params[:id]).purpose, post_path
    link "キャンバス", post_path
    parent :root
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