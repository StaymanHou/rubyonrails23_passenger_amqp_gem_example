if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    require 'eventmachine'
    require 'amqp'

    if forked
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
        AMQP.channel ||= AMQP::Channel.new(AMQP.connection)

        queue_name = "amqpgem.examples.rails23.passenger.index"
        AMQP.channel.queue(queue_name, :durable => true).subscribe do |message|
          Rails.logger.info Terminal.green("[AMQP] Received \"#{message}\" from #{queue_name}")
        end

      end
    end
  end
end
