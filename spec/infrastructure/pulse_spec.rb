require 'support/messaging_helper'
require production_code

describe Pulse, :celluloid do
  let!(:receiver) {MessageHelper.new 'foo'}

  before { ENV.delete "DISABLE_HOLLYWOOD_POLLING" }
  after { receiver.reset }

  it 'publishes an update message shortly after startup' do
    Pulse.new 'foo'
    sleep 0.1
    receiver.message_count.should == 1
  end

  it 'publishes update messages for a given channel every x seconds' do
    Pulse.new 'foo', interval: 1
    sleep 1.1
    receiver.message_count.should == 2
  end

  it "does not pulse if ENV['DISABLE_HOLLYWOOD_POLLING'] is set" do
    ENV["DISABLE_HOLLYWOOD_POLLING"] = "true"
    Pulse.new 'foo'
    sleep 0.2
    receiver.message_count.should == 0
  end

  it 'logs when it sends a pulse' do
    Pulse.new 'foo'
    sleep 0.1
    log_output.should include "INFO Pulse : sent foo -> update"
  end
end
