require 'support/messaging_helper'
require production_code

describe Clingfilm::Pulse, :celluloid do
  let!(:receiver) {MessageHelper.new 'foo'}

  before { ENV.delete "DISABLE_CLINGFILM_PULSES" }
  after { receiver.reset }

  it 'publishes an update message shortly after startup' do
    Clingfilm::Pulse.new 'foo'
    sleep 0.1
    expect(receiver.message_count).to eq 1
  end

  it 'publishes update messages for a given channel every x seconds' do
    Clingfilm::Pulse.new 'foo', interval: 1
    sleep 1.1
    expect(receiver.message_count).to eq 2
  end

  it "does not pulse if ENV['DISABLE_CLINGFILM_PULSES'] is set" do
    ENV["DISABLE_CLINGFILM_PULSES"] = "true"
    Clingfilm::Pulse.new 'foo'
    sleep 0.2
    expect(receiver.message_count).to eq 0
  end

  it 'logs when it sends a pulse' do
    Clingfilm::Pulse.new 'foo'
    sleep 0.1
    expect(log_output).to include "update -> foo"
  end
end
