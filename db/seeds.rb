if User.admin.count == 0
  puts "creating default admin:"
  attributes = {
    email: "moviggoAdm@moviggo.com",
    password: "mov12345",
    password_confirmation: "mov12345",
    nickname: "moviggo",
    name: "moviggo",
    privileges: [:admin]
  }
  puts attributes
  User.create!(attributes)
end

if ProviderCategory.count == 0
  [
    "Agua bidón/Gas",
    "Alimentos no preparados",
    "Alimentos preparados",
    "Bebidas alcohólicas",
    "Encomiendas",
    "Medicinas",
    "Panadería y pastelería",
    "Floristería",
    "Boletería"
  ].each do |category_name|
    ProviderCategory.where(
      titulo: category_name
    ).first_or_create
  end
end

if ProviderItemCategory.where(predeterminada: true).count == 0
  puts "creating default provider item category"
  ProviderItemCategory.create!(
    nombre: "General",
    predeterminada: true
  )
end

unless Place.where(nombre: "Loja").exists?
  puts "creating Loja"
  Place.create!(
    lat: "-3.996704",
    lon: "-79.201699",
    nombre: "Loja",
    country: "Ecuador",
    enabled: true
  )
end

unless Place.where(nombre: "Piura").exists?
  puts "creating Piura"
  Place.create!(
    lat: "-5.1930858",
    lon: "-80.6668063",
    nombre: "Piura",
    country: "Perú"
  )
end

Place.find_each do |place|
  if place.shipping_fares.count == 0
    puts "creating default shipping fares"
    ShippingFare.create!(
      place: place,
      price_cents: 150
    )
  end
end

unless SitePreference.exists?(name: "tos")
  puts "creating TOS"
  tos = File.read(Rails.root.join("config/default-tos.md"))
  SitePreference.create!(
    name: "tos",
    content: tos
  )
end
