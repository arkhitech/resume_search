
json.array!(@resumes) do |resume|
  json.extract! resume, :name, :telephone, :email
  <%#*json.url article_url(article, format: :json)%>
end