require production_code
require 'support/messaging_helper'

describe Hollywood::MessagingWrapper, :celluloid do
  let(:updatable) { double "Updatable", { :update => true } }
  let(:input_channel)  { "input_channel" }
  let(:other_channel)  { "other_channel" }
  let(:output_channel) { "output_channel" }

  subject { Hollywood::MessagingWrapper.new updatable, input_channel}

  it 'wraps a ruby object' do
    subject.wraps.should == updatable
  end

  it 'handles update messages' do
    updatable.should_receive(:update)
    subject.handle_message(input_channel, :update)
  end

  it 'handles updated messages' do
    updatable.should_receive(:update)
    subject.handle_message(input_channel, :updated)
  end

  it 'subscribes to messages on the given input channel' do
    updatable.should_receive(:update)
    subject
    MessageHelper.new.publish(input_channel, :update)
  end

  it 'only updates for messages on subscribed channels' do
    updatable.should_receive(:update).once
    subject
    MessageHelper.new.publish(other_channel, :update)
    MessageHelper.new.publish(input_channel, :update)
  end

  it 'only updates for update or updated messages' do
    updatable.should_receive(:update).twice
    subject
    # We can't use should_not_receive as it launches an exception into a foreign thread
    # If we want to use a matcher we can't match on 0 times, so do this to get around it
    MessageHelper.new.publish(input_channel,:not_an_update)
    MessageHelper.new.publish(input_channel,:update)
    MessageHelper.new.publish(input_channel,:updated)
  end

  describe 'when an update message is sent on a subscribed channel' do
    it 'triggers an update' do
      updatable.should_receive(:update).once
      subject
      MessageHelper.new.publish(input_channel,:updated)
    end

    it 'announces when it updates itself' do
      listener = MessageHelper.new 'foo'

      subject.updates 'foo'

      MessageHelper.new.publish(input_channel,:update)
      sleep 0.2
      listener.messages.last.should == ['foo',:updated]
    end

    it 'dies if the wrapped class exceptions' do
      updatable.stub(:update){raise 'some error'}

      subject
      MessageHelper.new.publish(input_channel,:update)

      subject.should_not be_alive
    end
  end

  it 'can listen for updates on multiple queues' do
    updatable.should_receive(:update).twice

    subject.depends_on 'foo'
    subject.depends_on 'bar'

    MessageHelper.new.publish('foo', :updated)
    MessageHelper.new.publish('bar', :updated)
  end

  it 'throws an exception if the content does not respond to #update' do
    expect {Hollywood::MessagingWrapper.new( double('un-updateable'), input_channel)}.to raise_error "Cannot wrap an object which doesn't provide #update"
  end

  describe '#new' do
    it 'can optionally be created with an output channel' do
      subject.class.new(updatable, input_channel, output_channel)
      listener = MessageHelper.new output_channel

      MessageHelper.new.publish(input_channel, :update)

      listener.messages.last.should == [output_channel, :updated]
    end

    it 'can optionally be created with multiple input channels' do
      updatable.should_receive(:update).twice

      subject.class.new(updatable, ['input_1', 'input_2'])

      MessageHelper.new.publish('input_1', :updated)
      MessageHelper.new.publish('input_2', :updated)
    end
  end

  describe '#to_s' do
    it 'mentions the wrapped class' do
      subject.to_s.should == "Hollywood::MessagingWrapper[#{updatable.class}]"
    end
  end

  describe 'logging' do
    let(:log_message){"-> #{input_channel}:updated"}

    context 'it does not update anything else' do
      it 'does not log when it updates' do
        MessageHelper.new.publish(input_channel,:update)
        subject
        log_output.should_not include log_message
      end
    end

    context 'it updates something else' do
      it 'logs when it updates' do
        subject.updates input_channel

        MessageHelper.new.publish(input_channel,:update)
        sleep 0.1
        log_output.should include log_message
      end
    end
  end
end
