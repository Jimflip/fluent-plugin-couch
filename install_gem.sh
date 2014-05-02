
#!/bin/bash
rm fluent-plugin-couch-*.gem
gem uninstall fluent-plugin-couch-sharded
gem build fluent-plugin-couch-sharded.gemspec
gem install fluent-plugin-couch-0.6.0.gem
