class DogsController < ApplicationController
  require 'will_paginate/array'

  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  before_action :current_user_is_dog_owner?, only: [:show]

  # GET /dogs
  # GET /dogs.json
  def index
    if params[:sort] == "likes"
      @dogs = Dog.sort_by_recent_likes.paginate(page: params[:page], per_page: 5)
    else 
      @dogs = Dog.paginate(page: params[:page], per_page: 5)
    end
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.owner = current_user
    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if !current_user_is_dog_owner?
        format.html { redirect_to @dog, notice: 'You are not authorized to edit this dog.'}
        format.json { render json: {"error": "not authorized"}, status: 401 } 
      elsif @dog.update(dog_params)
        # there's no way to remove images, but keeping implementation as is.
        @dog.images.attach(params[:dog][:images]) if params[:dog][:images].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end


    def current_user_is_dog_owner?
      @current_user_is_dog_owner = current_user && current_user == @dog.owner
      return @current_user_is_dog_owner
    end 
end
