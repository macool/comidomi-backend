json.products do
  json.array!(
    @products,
    partial: "product",
    as: :product
  )
end

json.meta do
  json.total_pages @products.total_pages
end
