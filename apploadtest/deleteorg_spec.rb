$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'blue-shell'
require 'cfdriver'
require 'rspec'

RSpec.configure do |c|
  c.include BlueShell::Matchers
end



describe "Deleting orgs" do
  it "should delete all the orgs" do
    177.times do |num|
      start_time = Time.now
      index = 2000 + num
      orgname = "cfdiag-org-#{index}"
      puts "Deleting org #{orgname}"
      delete_org orgname
      elapsed_time = Time.now - start_time
      puts "Completed operation in #{elapsed_time} seconds.\n\n"
    end
  end
end

