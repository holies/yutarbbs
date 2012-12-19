# encoding=utf-8

module Yutarbbs
  def my
    my = Mysql.connect '127.0.0.1', 'yutar', '', 'yutar'
    my.charset = 'utf8'
    my.query "SET time_zone='+09:00'"
    my
  end

  def with_sym_keys hash
    Hash[hash.map { |k,v| [ k.to_sym, v ] }] if hash
  end

  def fetch_one query, *params
    with_sym_keys my.prepare(query).execute(*params).fetch_hash
  end

  def fetch_all query, *params
    result = []
    my.prepare(query).execute(*params).each_hash do |e|
      result << with_sym_keys(e)
    end
    result
  end

  def h text
    text.gsub(/&/, '&amp;').gsub(/</, '&lt;')
  end

  def formattext text
    text
  end

  def formatphone text
    text.gsub /^(01[01679])(\d{3,4})(\d{4})$/, '\1-\2-\3'
  end

  def formatdate timestamp, with_time = false
    date = Time.at timestamp
    now = Time.now
    html = if now - date <= 5 * 60
      '<em>방금</em>'
    elsif date >= Time.local(now.year, now.month, now.day)
      '<em>오늘</em>'
    elsif date >= Time.local(now.year, now.month, now.day - 1)
      '어제'
    elsif date >= Time.local(now.year, now.month, now.day - 2)
      '그제'
    elsif date >= Time.local(now.year)
      date.strftime '%-m/%-d'
    else
      date.strftime "'%y %-m/%-d"
    end
    html << " #{date.strftime '%R'}" if with_time
    html
  end

  def number_format text
    text.to_s.gsub /(?<=\d)(?=(\d\d\d)+)$/, ','
  end
  
  def u *items
    uri "/#{items * '/'}", false, false
  end

  def hashpasswd text
    Digest::MD5.hexdigest "gkfd#{text}gkfd"
  end

  def forum_name
    %w/_ 공지 자유게시판 학술 PS 유타닷넷 운영 소모임 질문·토론 진로 테크/
  end

  def replace_emoticons html
    html
  end
end