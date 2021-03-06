RSpec.describe Dry::Schema::Result do
  before { Dry::Schema.load_extensions(:monads) }

  let(:schema) { Dry::Schema.define { required(:name).filled(:str?, size?: 2..4) } }

  context 'interface' do
    let(:input) { {} }

    it 'responds to #to_monad and #to_result' do
      expect(result).to respond_to(:to_monad)
      expect(result).to respond_to(:to_result)
    end
  end

  context 'with valid input' do
    let(:input) { { name: 'Jane' } }

    describe '#to_monad' do
      it 'returns a Success value' do
        monad = result.to_monad

        expect(monad).to be_a Dry::Monads::Result
        expect(monad).to be_success
        expect(monad.value!).to eql(name: 'Jane')
      end
    end
  end

  context 'with invalid input' do
    let(:input) { { name: '' } }

    describe '#to_monad' do
      it 'returns a Failure value' do
        monad = result.to_monad

        expect(monad).to be_failure
        expect(monad.failure).to eql(name: ['must be filled', 'length must be within 2 - 4'])
      end

      it 'returns full messages' do
        monad = result.to_monad(full: true)

        expect(monad).to be_a Dry::Monads::Result
        expect(monad).to be_failure
        expect(monad.failure).to eql(name: ['name must be filled', 'name length must be within 2 - 4'])
      end
    end
  end
end
