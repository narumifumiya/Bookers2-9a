class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  # 下記コードにて検索フォームからの情報を受け取る　formに合わせる
  # 検索モデル→params[:range]
  # 検索方法→params[:search]
  # 検索ワード→params[:word]
  
  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]
    
    if @range == "User"
      # user.ruとbook.rbに記述したself.looks(search,word)メソッドを使用
      @users = User.looks(@search, @word)
    else
      @books = Book.looks(@search, @word)
    end
  end
end
