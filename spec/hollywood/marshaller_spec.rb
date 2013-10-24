require 'timeout'
require production_code

class Foo; def update; end; end

describe Hollywood::Marshaller, :celluloid do

  subject{ Hollywood::Marshaller.run! }

  before(:each) do
    @actors = ActorHelper.new
  end

  context "when an actor is being supervised" do
    before do
      Hollywood::Marshaller.supervise Hollywood::MessagingWrapper, :as => :an_actor, :args => [Foo.new, 'test_channel_in', 'test_channel_out']
      subject
    end

    describe '#stop' do
      it 'terminates the actors' do
        @actors[:an_actor].should be_alive

        subject.stop
        Timeout::timeout(10) do
          sleep 0.01 while @actors[:an_actor] && @actors[:an_actor].alive?
        end

        actor = @actors[:an_actor]
        if actor
          expect(actor).to_not be_alive
        else
          expect(actor).to be_nil
        end
      end
    end

    context 'when an actor crashes' do
      it 'restarts the actor' do
        expect { @actors[:an_actor].crash_me }.to raise_error
        loop do
          sleep 0.01
          break if @actors[:an_actor].class != NilClass
        end
        expect(@actors[:an_actor]).to be_alive
      end

      it 'logs the crash' do
        expect { @actors[:an_actor].crash_me }.to raise_error
        expect(log_output).to include "Hollywood::MessagingWrapper crashed!"
      end

    end
  end
end
