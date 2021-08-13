class PostsController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @pagy, @posts = pagy(Post.order(id: :desc), items:3)
  end
  
  def show
    @post=Post.find(params[:id])
  end

  def new
    @post = Post.new
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿しました。'
      redirect_to root_url
    else
      @pagy, @posts = pagy(current_user.posts.order(id: :desc))
      flash.now[:danger] = '投稿に失敗しました。'
      render :new
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      flash[:success] = '正常に更新されました'
      redirect_to root_url
    else
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '削除しました。'
    redirect_to root_url
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end
