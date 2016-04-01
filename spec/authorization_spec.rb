describe StandupmailCli::Authorization do
  Authorization = StandupmailCli::Authorization

  let(:test_file) { '/tmp/sm_spec' }
  let(:user_token) { 'user_token' }
  let(:user_access_id) { 'user_access_id' }

  before do
    allow(Authorization).to receive(:token_file_path) { test_file }
  end

  context 'when there is token file in system' do
    before do
      token_hash = {}
      token_hash['user_token'] = user_token
      token_hash['user_access_id'] = user_access_id
      File.open(test_file, 'w') { |f| f.write token_hash.to_yaml }
    end

    after do
      expect(File.delete(test_file)).to eq(1)
    end

    it 'reads member token correctly' do
      expect(STDOUT).to receive(:puts).with("Wrong token or access id, please check your configuration file in \'~/.smrc\' and try again")
      Authorization.login
    end
  end

  context 'when there is no token file in system' do
    before do
      allow(Authorization).to receive(:read_token_from_stdin).and_return(user_token)
      allow(Authorization).to receive(:read_access_id_from_stdin).and_return(user_access_id)
      File.delete(test_file) if File.exist?(test_file)
      expect(File.exist?(test_file)).to be_falsey
    end

    describe 'stores the keys from STDIN to file' do
      it 'prompts user for the token and access id' do
        expect(Authorization).to receive(:read_token_from_stdin)
        expect(Authorization).to receive(:read_access_id_from_stdin)
        Authorization.login
      end

      it 'creates token file in system' do
        expect(File.exist?(test_file)).to be_falsey
        Authorization.login
        expect(File.exist?(test_file)).to be_truthy
      end

      it 'saves the key to the token file in system' do
        expect(File.exist?(test_file)).to be_falsey
        Authorization.login
        expect(File.open(test_file, 'r') { |f| f.read }).to include(user_token)
        expect(File.open(test_file, 'r') { |f| f.read }).to include(user_access_id)
      end
    end
  end
end
