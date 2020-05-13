class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index' 
  end

  get '/pets/new' do 
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do 
    puts !params["owner_name"]["name"].empty? && params["owner_id"] == nil
    @pet = nil
    if !params["owner_name"]["name"].empty? && params["owner_id"] == nil
      @new_owner = Owner.create(name: params["owner_name"]["name"])
      @pet = Pet.create(name: params["pet"]["name"], owner_id: @new_owner.id)
      puts 1
    elsif params["owner_name"]["name"].empty? && params["owner_id"] == nil
      @pet = Pet.create(name: params["pet"]["name"])
    else 
      @pet = Pet.create(name: params["pet"]["name"], owner_id: params["owner_id"].to_i)
    end

    puts @pet.name
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do 
    @owners = Owner.all
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  get '/pets/:id' do 
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  patch '/pets/:id' do 
    puts params
    @pet = Pet.find_by(id: params["id"])
    if !params["owner"]["name"].empty?
      @new_owner = Owner.find_by(name: params["owner"]["name"]) != nil ? Owner.find_by(name: params["owner"]["name"]) : Owner.create(name: params["owner"]["name"])
      @pet.name = params["pet"]["name"]
      @pet.owner = @new_owner
      @pet.save
      puts 1
    elsif params["owner"]["name"].empty? && params["owner"]["id"] != nil
      @pet.name = params["pet"]["name"]
      @pet.owner = Owner.find_by(id: params["owner"]["id"])
      @pet.save
    else 
      @pet.name = params["pet"]["name"]
      @pet.owner = nil
      @pet.save
    end
    
    puts @pet.owner.name

    redirect to "pets/#{@pet.id}"
  end
end