require 'bucket_sync_service.rb'

namespace :app do
  desc 'Fix things'
  task fix: :environment do
  end

  namespace :bucket do
    desc 'Sync bucket to dev from Scaleway'
    task :staging do
      Aws.config.update({
        region: ENV['SCALEWAY_OS_REGION'],
        credentials: Aws::Credentials.new(ENV['SCALEWAY_OS_ACCESS_KEY_ID'], ENV['SCALEWAY_OS_SECRET_ACCESS_KEY']),
        endpoint: ENV['SCALEWAY_OS_ENDPOINT']
      })
      syncer = BucketSyncService.new(ENV['SCALEWAY_OS_STAGING_BUCKET'], ENV['SCALEWAY_OS_BUCKET'])
      syncer.debug = true # log each object
      syncer.perform
    end
  end

  namespace :db do
    desc 'Get database from Scalingo'
    task :staging do
      Bundler.with_unbundled_env do
        Dotenv.load
        sh "scalingo --app #{ENV['SCALINGO_STAGING_APP_NAME']} backups-create --addon postgresql"
        sh "scalingo --app #{ENV['SCALINGO_STAGING_APP_NAME']} backups-download --addon postgresql --output db/scalingo-dump.tar.gz"

        sh 'rm -f db/latest.dump' # Remove an old backup file if it exists
        sh 'tar zxvf db/scalingo-dump.tar.gz -C db/' # Extract the new backup archive
        sh 'rm db/scalingo-dump.tar.gz' # Remove the backup archive
        sh 'mv db/*.pgsql db/latest.dump' # Rename the backup file
        sh 'DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop'
        sh 'bundle exec rails db:create'
        begin
          sh 'pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d ecotheque_development db/latest.dump'
        rescue
          'There were some warnings or errors while restoring'
        end
        sh 'rails db:migrate'
        sh 'rails db:seed'
      end
    end
  end

  namespace :search do
    desc 'Reindex models for search'
    task reindex: :environment do
      [Actor, Material, Page, Project, Technic].each do |model|
        puts "Reindexing #{model.count} #{model.model_name.human(count: 2)}"
        model.reindex
      end
    end
  end
  
end
