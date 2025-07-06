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
