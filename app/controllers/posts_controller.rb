class PostsController < ApplicationController
	before_action :authenticate_user!, except:[:index,:show]
  before_action :set_categories,only:[:index, :show]
  def index
    if params[:category].blank?
      @posts = Post.all.order("created_at DESC")
  	else
      category_id = Category.find_by(name: params[:category]).id
      @posts = Post.where(category_id: category_id).order("created_at DESC")
      end
  end

  def show
    @comment = Comment.new
	@post = Post.find(params[:id])
  end

  def new
  	@post = current_user.posts.new
  end

	def create
		@post = current_user.posts.new(post_params)
		respond_to do |format|
			if @post.save
				format.html{redirect_to @post,notice:"La pregunta se ha creado"}
				format.json {head :no_content}
			else
				format.html{render 'new', alert: "Problemas al crear la pregunta"}
				format.json{render.json :errors,status: unprocessable_entity}
		end
	  end
	end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
  	respond_to do |format|
  	if @post.update(post_params)
  		format.html{redirect_to @post, notice:"La pregunta se ha actualizado"}
				format.json {head :no_content}
					else
				format.html{render 'new', alert: "Problemas al actualizar la pregunta"}
				format.json{render.json :errors,status: unprocessable_entity}
  	end
  end
  end
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    respond_to do |format|
      format.html { redirect_to @post, notice: 'La pregunta se ha eliminado' }
      format.json { head :no_content }
    end
  end
  private
  def set_categories
      @categories = Category.all
  end
  def post_params
  	params.require(:post).permit(:title, :body, :category_id)
  	  end
end
