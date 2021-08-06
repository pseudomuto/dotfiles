# frozen_string_literal: true

module Dotfiles
  module Commands
    class Configure < Base
      def self.help
        "Configues system and application settings"
      end

      def execute
        CLI::UI::Frame.open("Configuring the system") do
          steps = [
            Steps::CloneRepo.new(repo: "robbyrussell/oh-my-zsh", path: File.join(BREW_PREFIX, "share/oh-my-zsh")),
            Steps::SetDefaultShell.new(shell: File.join(BREW_PREFIX, "bin/zsh")),
            Steps::VimPlug.new(plug_file: File.join(target_dir, ".vim", "Plugfile.vim")),
          ]

          steps.each(&method(:run_step))
        end
      end

      private

      def run_step(step)
        [step]
          .each_with_object(CLI::UI::SpinGroup.new) do |task, group|
            group.add(task.to_s) { task.apply unless task.applied? }
          end
          .wait
      end
    end
  end
end
