role :app, "172.16.2.165"
set :deploy_to, "/Users/ym/www/ymdrive"
set :scm_command, '/usr/local/bin/git'
set :user, "madeleine"
set :scm_passphrase, 'broadway'
default_run_options[:pty] = true