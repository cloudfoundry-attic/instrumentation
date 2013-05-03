require 'blue-shell'

$timeout = 600
def cf_target(name)
  BlueShell::Runner.run "cf target #{name}" do |runner|
    runner.should say "Setting target", $timeout
    runner.wait_for_exit $timeout
  end
end


def create_org(name)
  BlueShell::Runner.run "cf create-org #{name}" do |runner|
    runner.should say "There are no spaces.", $timeout
    runner.wait_for_exit $timeout
  end
end

def create_user(name)
  BlueShell::Runner.run "cf create-user #{name} --password p --verify p" do |runner|
    runner.should say "Creating user... OK", $timeout
    runner.wait_for_exit $timeout
  end
  login_as(name, "p")
end

def login_as(name, password)
  # pass the organization flag to prevent cf from prompting us for an org
  # note that cf gives an error message, but we don't care
  command = "cf login #{name} --password '#{password}' --organization"

  BlueShell::Runner.run command do |runner|
    runner.should say "Authenticating... OK", $timeout
    runner.wait_for_exit $timeout
  end
end

def push_app_no_ask(name, path)
  BlueShell::Runner.run "cf push --name #{name} --no-create-services --no-bind-services --memory 512M --instances 1 --host #{name} --domain #{$domain} --no-manifest --path #{path}" do |runner|
    runner.should say("instances: 1 running", $timeout)
    runner.wait_for_exit $timeout
  end
end

def create_space(name)
  BlueShell::Runner.run "cf create-space #{name}" do |runner|
    runner.should say "Space created!", $timeout
    runner.wait_for_exit $timeout
  end
  BlueShell::Runner.run "cf switch-space #{name}" do |runner|
    runner.should say "Switching to space #{name}... OK", $timeout
    runner.wait_for_exit $timeout
  end
end

def delete_org(name)
  BlueShell::Runner.run "cf delete-org #{name} -r --force" do |runner|
    runner.should say "Deleting organization", $timeout
    runner.wait_for_exit $timeout
  end
end