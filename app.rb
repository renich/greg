#!/usr/bin/env ruby

# requires
require 'bundler'

# setup
Bundler.require


class Greg < Sinatra::Base
    before do
        expires 60, :public, :must_revalidate
    end

    get '/' do
        stories = []
        File.open('data/feeds.txt', 'r').each_line { |f|
            feed = Feedjira::Feed.fetch_and_parse( f.strip )
            stories.push( *feed.entries )
        }

        #eruby = Erubis::Eruby.new( File.read( 'news.eruby' ) )
        #out.write(eruby.result(binding()))

        stories.sort_by! { |story| story[ :published ] }.reverse!

        slim :index, locals: { items: stories }
    end

    run! if app_file == $0
end
