module AwsService
  def self.push_to_queue_cancel(title, tag)
    data = {job: "cancel", title: title, tag: tag}
    send_message_to_queue(data, 'bot_jobs', nil)
  end

  def self.send_message_to_queue(message, job_type, attributes=nil)
    queue = get_queue(job_type)
    if queue.nil?
      logger.note({ fail_send_queue: message })
    else
      logger.note({ send_queue: message })
      if attributes.nil?
        queue.send_message(message.to_json)
      else
        queue.send_message(message.to_json, attributes)
      end
    end
  end

  def self.get_queue(job_type)
    begin
      sqs = AWS::SQS.new
      sqs.queues.named(Settings.environments.sqs[job_type].name)
    rescue
      nil
    end
  end

  private
    def self.logger
      Fluent::Logger.service_logger
    end
end
