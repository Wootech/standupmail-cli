describe StandupmailCli::Managment do
  Managment = StandupmailCli::Managment
  Request = StandupmailCli::Request

  let(:teams) { [{"id": 413, "name": "Development", "owner_id": 871, "email": "Development_413@app.standupmail.com", "created_at": "2015-06-02T09:30:07.180Z", "members": [{"id": 871, "email": "john.smith@gmail.com", "name": "john", "role": "", "business_name": "", "account_type_name": "professional", "free_members_count": 1, "timezone_name": "Europe/Berlin", "created_at": "2015-05-28T17:47:11.259Z"}, { "id": 954, "email": "cyndi.lauper@gmail.com", "name": "cyndi", "role": "", "business_name": "", "account_type_name": "trial", "free_members_count": 0, "timezone_name": "Europe/Berlin", "created_at": "2015-06-02T15:32:37.580Z" }]}, {"id": 423, "name": "test", "owner_id": 871, "email": "test_423@app.standupmail.com", "created_at": "2015-06-04T14:02:19.440Z", "members": [{ "id": 871, "email": "john.smith@gmail.com", "name": "john", "role": "", "business_name": "", "account_type_name": "professional", "free_members_count": 1, "timezone_name": "Europe/Berlin", "created_at": "2015-05-28T17:47:11.259Z" }]}] }
  let(:messages) { [{ "date": "Tue 02 Jun 2015", "messages": [{ "id": 31515, "user_id": 871, "user_name": "john", "additional_state": "", "message": [{ "type": "working", "msg": "sth" }, { "type": "blocked", "msg": "sth" }, { "type": "done", "msg": "sth" }]}, { "id": "", "user_id": 954, "user_name": "cyndi", "additional_state": "didn't answer", "message": []} ]}, { "date": "Thu 04 Jun 2015", "messages": [{ "id": 31618, "user_id": 871, "user_name": "sm", "additional_state": "", "message": [{ "type": "working", "msg": "test" }]}, { "id": 31619, "user_id": 954, "user_name": "cyndi", "additional_state": "", "message": [{ "type": "blocked", "msg": "test" }] }] }] }
  let(:fake_messages) {[]}

  before do
    allow(Request).to receive(:get_teams).and_return(teams)
    allow(Request).to receive(:get_digest).and_return(messages)
    allow(Request).to receive(:post_messages).with(Fixnum, anything)
  end

  describe '#teams' do
    it 'return user teams list' do
      teams = Managment.teams
      expect(teams).to eq("[0] Development\n[1] test\n")
      expect(teams).to be_kind_of(String)
    end
  end

  describe '#digest' do
    it 'Show text, digest was empty for this day' do
      date_range = '2016-01-12..2016-01-13'
      allow(Request).to receive(:get_digest).and_return(fake_messages)
      digest = Managment.digest(0, date_range)
      expect(digest).to eq("Sorry, digest was empty for this day.\n")
    end

    it 'Show message, for this date' do
      date_range = '2015-06-01..2015-06-02'
      response = "--------------------------\nDigest for Tue 02 Jun 2015\n--------------------------\n\njohn:\n   \e[34m→\e[0m  sth\n   \e[31m⨉\e[0m  sth\n   \e[32m✓\e[0m  sth\n\ncyndi:\n   didn't answer\n"
      digest = Managment.digest(0, date_range)
      expect(digest).to be_kind_of(String)
      expect(digest).to eq(response)
    end
  end

  describe '#prepare_message' do
    it 'post done message' do
      method = Managment.prepare_message(0, 'done', nil, nil)
      expect(method).to eq("Well done!\n")
    end

    it 'post working message' do
      method = Managment.prepare_message(0, nil, 'working', nil)
      expect(method).to eq("Stay hungry! Stay foolish!\n")
    end

    it 'post blocked message' do
      method = Managment.prepare_message(0, nil, nil, 'blocked')
      expect(method).to eq("Everything will gonna be ok!\n")
    end
  end
end
