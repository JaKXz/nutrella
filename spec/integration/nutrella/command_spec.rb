module Nutrella
  vcr_options = { cassette_name: "nutrella", record: :new_episodes }

  RSpec.describe "Nutrella", vcr: vcr_options do
    it "finds an existing board" do
      subject = command("-t", "Nutrella")

      expect(subject).to receive(:system).with(match(%r{open https://trello.com/b/.*/nutrella}))

      subject.run
    end

    it "creates a new board" do
      subject = command("-t", "fresh_task_board")
      allow(subject).to receive(:confirm_create?).and_return(true)

      expect(subject).to receive(:system).with(match(%r{open https://trello.com/b/.*/fresh-task-board}))

      subject.run
    end

    it "fails when options don't parse" do
      expect { Command.new(["--invalid-option"]).run }.to(
        output(/Error: invalid option/).to_stderr.and(raise_error(SystemExit))
      )
    end

    def command(*args)
      Command.new(args)
    end
  end
end
