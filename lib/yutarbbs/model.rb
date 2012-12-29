require 'dm-core'
require 'dm-aggregates'
require 'dm-adjust'

module Yutarbbs::Model

  DataMapper::Logger.new $stdout, :debug
  
  DataMapper.setup :default, 'mysql://yutar@127.0.0.1/yutar'

  DataMapper.repository(:default).adapter.resource_naming_convention =
    DataMapper::NamingConventions::Resource::UnderscoredAndPluralizedWithoutModule

  class User
    include DataMapper::Resource

    property :id, Serial, field: 'uid'
    property :userid, String, required: true, lazy: [ :detail ]
    property :passwd, String, required: true, lazy: true
    property :name, String, required: true
    property :year, Integer, required: true
    property :phone, String, required: true, lazy: [ :detail ]
    property :email, String, required: true, lazy: [ :detail ]
    property :remark, Text, required: true, lazy: [ :detail ]
    property :updated_on, Date, required: true, lazy: [ :detail ]

    has n, :articles, parent_key: [ :id ], child_key: [ :uid ]
  end

  class Article
    include DataMapper::Resource

    storage_names[:default] = 'threads'

    property :id, Serial, field: 'tid'
    property :fid, Integer, required: true
    property :subject, String, required: true
    property :message, Text, required: true
    property :created_at, DateTime, required: true
    property :hits, Integer, required: true
    property :attachment, String

    belongs_to :user, child_key: [ :uid ], parent_key: [ :id ]

    has n, :messages, parent_key: [ :id ], child_key: [ :tid ]
  end

  class Message
    include DataMapper::Resource

    property :id, Serial, field: 'mid'
    property :message, Text, required: true
    property :created_at, DateTime, required: true

    belongs_to :user, child_key: [ :uid ], parent_key: [ :id ]
    belongs_to :article, child_key: [ :tid ]
  end

  DataMapper.finalize

end
