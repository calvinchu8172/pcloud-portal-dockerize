namespace :product_category do

  task :create => :environment do
    puts "Create category. Please enter category name:"
    name = STDIN.gets.chomp
    category = Category.create(name: name)
    if category.valid?
      puts "#{name} is created."
    else
      puts category.errors.messages
    end
  end

  task :show => :environment do
    puts "Show all category."
    categories = Category.all
    categories.each do |category|
      puts category.inspect
    end
  end

  task :update => :environment do
    puts "Update category. Please enter category name:"
    name = STDIN.gets.chomp
    category = Category.find_by_name(name)
    if category.nil?
      abort "#{name} does not exist."
    end
    puts "Please enter NEW category name:"
    new_name = STDIN.gets.chomp
    done = category.update_attributes!(name: new_name)

    if done
      puts "#{name} is updated to #{new_name}."
    else
      puts done.errors.messages
    end
  end

  task :delete => :environment do
    puts "Delete category. Please enter category name:"
    name = STDIN.gets.chomp
    category = Category.find_by_name(name)
    if category.nil?
      puts "#{name} does not exist."
    elsif category.destroy
      puts "#{name} is deleted."
      ActiveRecord::Base.connection.execute('ALTER TABLE categories AUTO_INCREMENT = 1')
    end
  end

end

namespace :product do

  task :update_all_show_column => :environment do
    puts "Update all products show column to true"
    products = Product.all
    products.each do |product|
      done = product.update_attributes!(show: true)
      if done
        puts "#{product.id} #{product.name}: show is updated to #{product.show}."
      else
        puts done.errors.messages
      end
    end
  end

  task :update_single_show_column => :environment do
    puts "Update a product show column to true. Please enter product name:"
    name = STDIN.gets.chomp
    product = Product.find_by_name(name)
    if product.nil?
      abort "#{name} does not exist."
    end
    puts "Please enter 1 or 0 (true or false):"
    enter = STDIN.gets.chomp
    if enter == '1'
      show = true
    elsif enter == '0'
      show = false
    else
      abort "Wrong value."
    end
    done = product.update_attributes!(show: show)

    if done
      puts "#{product.id} #{product.name}: show is updated to #{product.show}."
    else
      puts done.errors.messages
    end
  end

end