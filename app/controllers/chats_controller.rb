class ChatsController < ApplicationController
  # 相互フォローしてなかったら投稿一覧ページへ遷移する
  before_action :reject_non_related, only: [:show]

  def show
    @user = User.find(params[:id])
    # current_userのUserRoomがもつroom_idを全て読み込む
    rooms = current_user.user_rooms.pluck(:room_id)
    # UserRoomモデルからuser(pramas[:id])と上記のroomsで読み込んだroom_idが一致するデータを取り出す
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # user_roomsが存在しないならtrue、存在するならfalseとなる。unlessの為、falseなら処理、trueならelseで処理をする
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
      # current_userとuser(params{:id})に共通の@room.idを持つuser_roomを作る
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end

    # chat一覧用　current_userとuser(params{:id})が共通のroom_idを持っている@roomからchatsテーブルを全て読み込む
    @chats = @room.chats
    # チャット投稿用　フォームで使う
    @chat = Chat.new(room_id: @room.id)

  end

  def create
    # @chatは非同期通信でjs.erbで使用する為インスタンス変数としている。
    @chat = current_user.chats.new(chat_params)
    # falseで実行 saveができなかったら、validater.js.erbにrenderする（非同期通信）
    unless @chat.save
      render :validater
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  # 相互フォローしてなかったら投稿一覧ページへ遷移する
  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end

end
