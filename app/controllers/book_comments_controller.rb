class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = book.id
    @book_comment.save
    # redirect_back fallback_location: root_path 下の記述の方が良い？
    # redirect_to request.referer
    # render :book_comments

  end

  def destroy
    # 削除するコメントを見つける
    # 　　　　　　　　　comment.id↓　　　commentに紐づいたbook_id↓
    @book_comment = BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
    # 下記の記述でも問題ない。
    # book_comment = BookComment.find(params[:id])
    # book_comment.destroy
    # render :book_comments
    # redirect_back fallback_location: root_path　下の記述の方が良い？
    # redirect_to request.referer
  end


  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end
