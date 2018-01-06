require 'sinatra/base'
require 'sinatra/json'
require 'thin'
require_relative 'lib/blockchain.rb'
require 'json'
require 'pry'

class Odyn < Sinatra::Base
  attr_accessor :transactions

  configure do
    set server: "thin"
    set port: 9999
    set traps: false
    set logging: nil
    set quiet: true
  end

  def initialize
    @blockchain = Blockchain.new

    super
  end

  get '/transactions' do
    content_type :json
    @blockchain.unprocessed_transactions.to_json
  end

  get '/chain' do
    content_type :json
    @blockchain.chain.to_json
  end

  post '/transactions/new' do
    @blockchain.add_transaction( params[:sender], params[:recipient], params[:amount] ).to_json
  end
end

Odyn.run!
