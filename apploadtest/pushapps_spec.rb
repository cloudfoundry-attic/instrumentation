$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'blue-shell'
require 'cfdriver'
require 'rspec'

$index = 0
$runner = ENV['RUNNER'] || "TEST"
$appdir = ENV['APPDIR']
$domain = ENV['DOMAIN']
$adminpw = ENV['ADMINPWD']
$total = (ENV['APPCOUNT'] || "500").to_i
$prefix = ENV['CFAPPPREFIX'] || "cfapp"

RSpec.configure do |c|
  c.include BlueShell::Matchers
end

describe "Pushing apps" do
  before(:all) do
    $domain.should_not be_nil
    $adminpw.should_not be_nil
    cf_target("api." + $domain)
  end

  $total.times do |num|
    it "runner #{$runner} deploys app number #{num} of #{$total}" do
      login_as("admin", $adminpw)
      output = "Runner #{$runner} pushing app number #{num}\n"
      start_time = Time.now
      index = $index + num
      basename = "#{$prefix}-#{$runner}-#{index}"
      orgname = "#{basename}-org"
      username = "#{basename}-user"
      spacename = "#{basename}-space"
      appname = "#{basename}-app"
      output << "...Creating org #{orgname}\n"
      create_org orgname
      output << "...Creating user #{username}\n"
      create_user username
      output << "...Creating space #{spacename}\n"
      create_space spacename
      output << "...Pushing app #{appname}\n"
      push_app_no_ask appname, $appdir
      elapsed_time = Time.now - start_time
      puts "#{output}Completed app push in #{elapsed_time} seconds.\n\n"
    end
  end

end
