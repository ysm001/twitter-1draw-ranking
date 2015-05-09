namespace :one_draw do
  namespace :illust do

    desc 'fetch illusts from twitter'
    task :fetch, [:genre_id] => :environment do |t, args|
      logger = Logger.new('log/fetch.log')
      genre = Genre.find_by_id args.genre_id

      logger.info "#{Time.now} -- #{genre.hash_tag} fetch start --"
      begin
        tweets = Tweet.fetch genre
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch end (#{tweets.size} fetched)--"
      rescue => e
        logger.info "#{Time.now} -- #{genre.hash_tag} fetch error (#{e}) --"
        logger.info e.backtrace
      end
    end

    desc 'update tweets posted within [since] days'
    task :update, [:since] => :environment do |t, args|
      logger = Logger.new('log/update.log')

      to = Time.now
      from = Date.today.to_time - (60 * 60 * 24 * args.since.to_i)

      logger.info "#{Time.now} -- update start --"
      begin
        values = Tweet.update_by_period from...to
        logger.info "#{Time.now} -- update end (#{values.size} updated)--"
      rescue => e
        logger.info "#{Time.now} -- update error (#{e})--"
        logger.info e.backtrace
      end
    end

    task fetch_and_update: :environment do
    end

    desc ''
    task fetch_and_update: :environment do
      Rake::Task["one_draw:illust:fetch"].invoke 2
      Rake::Task["one_draw:illust:update"].invoke 1
    end
  end
end
