namespace :status do
  task :status_not_relevanted => :environment do
    @messages = Message.all
    @messages.each do |message|
      @data=Time.now
      if (@data.month - message.created_at.month) == 3
        message.not_relevanted
        p message
        message.save
      end
    end
  end
end
