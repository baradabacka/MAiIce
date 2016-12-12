namespace :status do
  task :status_not_relevanted => :environment do
    Message.all.each do |message|
      if (3.month.ago >= message.created_at && message.may_not_relevanted?)
        message.not_relevanted!
      end
    end
  end
end
