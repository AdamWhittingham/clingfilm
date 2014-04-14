require production_code
require 'support/messaging_helper'
require 'support/celluloid_hooks'

describe Clingfilm::MessagingWrapper, :celluloid do
  let(:wrapped)        { double "wrapped",  { :update => true } }
  let(:input_channel)  { "input_channel" }
  let(:other_channel)  { "other_channel" }
  let(:output_channel) { "output_channel" }
  let(:some_data)      { double "some data" }
  let!(:listener)      { MessageHelper.new(output_channel) }

  subject! { Clingfilm::MessagingWrapper.new(wrapped, input_channel, output_channel) }

  describe '#new' do
    it 'throws an exception if the wrapped object does not respond to #update' do
      expect { Clingfilm::MessagingWrapper.new( double('un-updateable'), input_channel, output_channel)}.to raise_error "Cannot wrap an object which doesn't provide #update"
    end

    it 'can optionally be created with multiple input channels' do
      Clingfilm::MessagingWrapper.new(wrapped, ['input_1', 'input_2'], output_channel)
      MessageHelper.new.publish('input_1', :updated)
      MessageHelper.new.publish('input_2', :updated)
      expect(wrapped).to have_received(:update).twice
    end
  end

  describe '#to_s' do
    it 'mentions the wrapped class' do
      expect(subject.to_s).to eq "Clingfilm::MessagingWrapper[#{wrapped.class}]"
    end
  end

  describe "#wraps" do
    it 'wraps the given object' do
      expect(subject.wraps).to eq wrapped
    end
  end

  describe "messaging" do
    describe "incomming" do
      it 'calls wrapped#update when receiving a message on a subscribed channel' do
        MessageHelper.new.publish(input_channel, :update)
        expect(wrapped).to have_received :update
      end

      it 'does not update for messages on non-subscribed channels' do
        MessageHelper.new.publish(other_channel, :update)
        expect(wrapped).to_not have_received :update
      end

      it 'can subscribe to multiple input channels' do
        subject.depends_on 'foo'
        MessageHelper.new.publish('input_channel', :updated)
        MessageHelper.new.publish('foo', :updated)
        expect(wrapped).to have_received(:update).twice
      end

    end

    describe "outgoing" do
      it 'announces the return of wrapper#update on the output channel' do
        wrapped.stub(update: some_data)
        MessageHelper.new.publish(input_channel, :update)
        expect(listener.messages).to include [output_channel, some_data]
      end

      it 'does not announce if the wrapped object returns nil' do
        wrapped.stub(update: nil)
        MessageHelper.new.publish(input_channel, :update)
        expect(listener).to_not be_updated
      end

      it 'dies if the wrapped class exceptions' do
        wrapped.stub(:update){raise 'some error'}
        MessageHelper.new.publish(input_channel, :update)
        expect(subject).to_not be_alive
      end
    end
  end

  describe 'logging' do
    context "at the INFO level" do
      it 'logs when it announces' do
        wrapped.stub(update: :output)
        MessageHelper.new.publish(input_channel, :update)
        sleep 0.1
        log_output.should include "INFO Celluloid : #{wrapped.class} -> #{output_channel}"
      end

      it 'logs when a message is received' do
        MessageHelper.new.publish(input_channel, :update)
        sleep 0.1
        log_output.should include "INFO Celluloid : #{wrapped.class} <- #{input_channel}"
      end
    end

    context "at the DEBUG level" do
      it 'logs what it announces' do
        MessageHelper.new.publish(input_channel, :update)
        sleep 0.1
        log_output.should include "DEBUG Celluloid : #{wrapped} >> #{output_channel} = true"
      end

      it 'logs the messages are received' do
        MessageHelper.new.publish(input_channel,:update)
        sleep 0.1
        log_output.should include "DEBUG Celluloid : #{wrapped} << #{input_channel} = update"
      end
    end

  end
end
