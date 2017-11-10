module AwsService
  def self.push_to_queue_cancel(title, tag)
    data = {job: "cancel", title: title, tag: tag}
    send_message_to_queue(data, 'bot_jobs', nil)
  end

  def self.send_message_to_queue(message, job_type, attributes=nil)
    # sqs = AWS::SQS.new
    # sqs.queues.named(Settings.environments.sqs[job_type].name)
    sqs = Aws::SQS::Client.new
    resp = sqs.get_queue_url({
      queue_name: Settings.environments.sqs[job_type].name
    })

    if resp.queue_url.nil?
      logger.note({ fail_send_queue: message })
    else
      logger.note({ send_queue: message })
      if attributes.nil?
        sqs.send_message({
          queue_url: resp.queue_url,
          message_body: message.to_json
        })
      else
        sqs.send_message({
          queue_url: resp.queue_url,
          message_body: message.to_json,
          message_attributes: attributes
        })
      end
    end
  end

  # def self.get_queue(job_type)
  #   begin

  #   rescue
  #     nil
  #   end
  # end

  private
    def self.logger
      Fluent::Logger.service_logger
    end
end
