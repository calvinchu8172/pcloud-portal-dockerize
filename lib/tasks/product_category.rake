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