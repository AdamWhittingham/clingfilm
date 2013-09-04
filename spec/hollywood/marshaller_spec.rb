require 'timeout'
require production_code

class Foo; def update; end; end

describe Hollywood::Marshaller, :celluloid do

  subject{ Hollywood::Marshaller.run! }

  before(:each) do
    @actors = ActorHelper.new
  end

  describe '.run!' do
    it 'configures the logger' do
      subject
      Celluloid.logger.name.should == 'Backend'
    end
  end

  context "when an actor is being supervised" do
    before do
      Hollywood::Marshaller.supervise Hollywood::MessagingWrapper, :as => :an_actor, :args => [Foo.new, 'test_channel_in', 'test_channel_out']
      subject
    end

    describe '#stop!' do
      it 'terminates the actors' do
        @actors[:an_actor].should be_alive

        subject.stop!
        Timeout::timeout(10) do
          sleep 0.1 while @actors[:an_actor].alive?
        end

        @actors[:an_actor].should_not be_alive
      end
    end

    context 'when an actor crashes' do
      it 'restarts the actor' do
        expect { @actors[:an_actor].crash_me }.to raise_error
        sleep 0.5 # give it a chance to restart
        @actors[:an_actor].should be_alive
      end

      it 'logs the crash' do
        expect { @actors[:an_actor].crash_me }.to raise_error
        sleep 0.5 # give it a chance to restart
        log_output.should include "ERROR Backend : Hollywood::MessagingWrapper crashed!"
      end
    end
  end
end
