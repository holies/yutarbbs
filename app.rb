require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/session'
require 'mysql'
require './lib/yutarbbs'
also_reload './lib/yutarbbs.rb' if development?

Encoding.default_external = Encoding::UTF_8

include Yutarbbs

set :layout, true
set :session_name, 'yutarbbs'
set :session_secret, ''

get '/' do
  @notice = fetch_one 'SELECT * FROM threads WHERE fid = 1 ORDER BY created_at DESC'
  redirect to "/thread/#{@notice[:tid]}" if session?
  erb :index
end

get '/gateway' do
  session_end!
  redirect back
end

post '/gateway' do
  user = fetch_one 'SELECT uid, year, name, userid, IFNULL(updated_on + INTERVAL 3 MONTH, 0) < NOW() outdated FROM users WHERE userid = ? AND passwd = ? LIMIT 1', params[:userid], hashpasswd(params[:passwd])
  if user
    session_start!
    user.each do |k,v|
      session[k] = v unless k == :outdated
    end
    # session[:persistent] = params[:persistent]
    puts user
    redirect to '/me' if user[:outdated].nonzero?
  else
    session_end!
  end
  redirect back
end

get '/login' do
  erb :auth
end

get '/me' do
  session!
  'ok'
end

get '/users' do
  session!
  'ok'
end

get '/forum' do
  session!
  'ok'
end

get '/thread/:tid' do |tid|
  session!
  # if ($_COOKIE['lasttid'] != $tid) {
  #   update('threads', 'hits = hits + 1', array('tid = ? AND uid != ?', $tid, $my->uid), 1);
  #   setcookie('lasttid', $tid);
  # }
  @thread = fetch_one 'SELECT tid, fid, subject, t.uid, year, name, phone, email, remark, message, UNIX_TIMESTAMP(created_at) created, attachment FROM threads t INNER JOIN users USING (uid) WHERE tid = ? LIMIT 1', tid
  not_found unless @thread
  @messages = fetch_all 'SELECT mid, message, uid, year, name, UNIX_TIMESTAMP(created_at) created FROM messages INNER JOIN users USING (uid) WHERE tid = ? ORDER BY created_at', tid
  @path = "./www/attachment/#{@thread[:tid]}-#{@thread[:attachment]}"
  @size = nil
  # if (is_readable($path) && is_file($path))
    # $size = filesize($path);
  erb :thread
end

get '/thread/:tid/:modifier' do |tid, modifier|
  session!
  case modifier
  when 'next'
    thread = fetch_one 'SELECT b.tid FROM threads a, threads b WHERE a.tid=? AND b.fid=a.fid AND b.tid<a.tid ORDER BY b.tid DESC LIMIT 1', tid
  when 'prev'
    thread = fetch_one 'SELECT b.tid FROM threads a, threads b WHERE a.tid=? AND b.fid=a.fid AND b.tid>a.tid ORDER BY b.tid LIMIT 1', tid
  end
  redirect to "/thread/#{thread[:tid]}" if thread
  error 204
end

get '/rss' do
  'ok'
end

get '/edit_thread' do
  session!
  'ok'
end

get '/delete_thread' do
  session!
  'ok'
end

get '/delete_message' do
  session!
  'ok'
end

get '/message' do
  session!
  'ok'
end

get '/emoticons' do
  session!
  'ok'
end
