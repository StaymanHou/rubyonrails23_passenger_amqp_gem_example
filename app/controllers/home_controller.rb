class HomeController < ApplicationController
  def index
    message = params.inspect
    @called = 0
    AMQP.channel.default_exchange.publish(message, :routing_key => "amqpgem.examples.rails23.passenger.index") do
      Rails.logger.info Terminal.yellow("[AMQP] Published \"#{message}\"")
    end
    render :text => "Hello, world! Check your terminal log."
  end # index
end # class HomeController
