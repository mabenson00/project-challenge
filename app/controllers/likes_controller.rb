class LikesController < ApplicationController
  before_action :find_dog

  def create
    @like = @dog.likes.new(user_id: current_user.id)
      respond_to do |format|
      if @like.save
        format.html { redirect_to @dog, notice: 'You liked this' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { redirect_to @dog, notice: 'You did not this'}
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_dog
    @dog = Dog.find(params[:dog_id])
  end
end
