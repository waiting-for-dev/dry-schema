# frozen_string_literal: true

RSpec.describe Dry::Schema::AstErrorCompiler, '#call' do
  subject(:ast_error_compiler) { Dry::Schema::AstErrorCompiler.new }

  it 'returns an empty hash when there are no errors' do
    expect(ast_error_compiler.([])).to be_empty
  end
end
