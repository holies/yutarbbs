module Yutarbbs
  class WebApp
    get '/delete_message/*' do |mid|
      session!
      Message.all(uid: session[:id]).get(mid).destroy if params[:y]
      redirect back
    end

    post '/message' do
      session!
      Message.create(
        tid: params[:tid],
        message: params[:message],
        created_at: Time.now,
        uid: session[:id],
      )
      redirect back
    end
  end
end
