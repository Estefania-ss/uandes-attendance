# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Crear usuarios de prueba con diferentes roles
puts "Creando usuarios de prueba..."

# Usuario de admisión
admision_user = User.find_or_create_by!(email: 'admision@uandes.cl') do |user|
  user.name = 'Equipo Admisión'
  user.password = '123456'
  user.password_confirmation = '123456'
  user.role = 'admisión'
end

# Usuario embajador
embajador_user = User.find_or_create_by!(email: 'embajador@uandes.cl') do |user|
  user.name = 'Embajador Test'
  user.password = '123456'
  user.password_confirmation = '123456'
  user.role = 'embajador'
end

puts "Usuarios creados:"
puts "- Admisión: #{admision_user.email} (contraseña: 123456)"
puts "- Embajador: #{embajador_user.email} (contraseña: 123456)"

# Crear eventos de prueba
puts "Creando eventos de prueba..."

# Eventos pasados
Event.find_or_create_by!(name: 'Charla de Ingeniería 2023') do |event|
  event.date = Date.current - 30.days
  event.event_type = 'charla'
  event.campaign_id = 'CAMP2023-001'
end

Event.find_or_create_by!(name: 'Seminario de Medicina 2023') do |event|
  event.date = Date.current - 15.days
  event.event_type = 'seminario'
  event.campaign_id = 'CAMP2023-002'
end

Event.find_or_create_by!(name: 'Workshop de Programación 2023') do |event|
  event.date = Date.current - 7.days
  event.event_type = 'workshop'
  event.campaign_id = 'CAMP2023-003'
end

# Eventos futuros
Event.find_or_create_by!(name: 'Charla de Ingeniería 2024') do |event|
  event.date = Date.current + 7.days
  event.event_type = 'charla'
  event.campaign_id = 'CAMP2024-001'
end

Event.find_or_create_by!(name: 'Seminario de Medicina 2024') do |event|
  event.date = Date.current + 15.days
  event.event_type = 'seminario'
  event.campaign_id = 'CAMP2024-002'
end

Event.find_or_create_by!(name: 'Conferencia de Negocios 2024') do |event|
  event.date = Date.current + 30.days
  event.event_type = 'conferencia'
  event.campaign_id = 'CAMP2024-003'
end

Event.find_or_create_by!(name: 'Taller de Liderazgo 2024') do |event|
  event.date = Date.current + 45.days
  event.event_type = 'taller'
  event.campaign_id = 'CAMP2024-004'
end

puts "Eventos de prueba creados:"
puts "- 3 eventos pasados (no editables)"
puts "- 4 eventos futuros (editables)"


# 