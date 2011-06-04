PhusionPassenger.on_event(:starting_worker_process) do |forked|
  if forked
    require 'eventmachine'
    require 'amqp'

    Rails.logger.info "[AMQP] Initializing amqp..."
    amqp_thread = Thread.new {
      failure_handler = lambda {
        Rails.logger.fatal Terminal.red("[AMQP] [FATAL] Could not connect to AMQP broker")
      }
      AMQP.start(:on_tcp_connection_failure => failure_handler)
    }
    amqp_thread.abort_on_exception = true
    sleep(0.15)

    EventMachine.next_tick do
      queue_name = "amqpgem.examples.rails23.passenger.warmup"
      AMQP.channel ||= AMQP::Channel.new(AMQP.connection)
      AMQP.channel.queue(queue_name, :durable => true)

      message = "Warmup message"
      AMQP.channel.default_exchange.publish(message, :routing_key => queue_name) do
        Rails.logger.info Terminal.yellow("[AMQP] Published \"#{message}\" to #{queue_name}")
      end

      other_queue = "amqpgem.examples.rails23.passenger.index"
      AMQP.channel.queue(other_queue, :durable => true).subscribe do |message|
        Rails.logger.info Terminal.green("[AMQP] Received \"#{message}\" from #{other_queue}")
      end

    end
  end
end
