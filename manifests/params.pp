# == Class: stash::params
#
# Defines default values for stash module
#
class stash::params {
  case $::osfamily {
    /RedHat/: {
      if $::operatingsystemmajrelease == '7' {
        $json_packages           = 'rubygem-json'
        # /etc/systemd/system because https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sect-Managing_Services_with_systemd-Unit_Files.html
        # https://wiki.archlinux.org/index.php/systemd#Writing_unit_files
        # /usr/lib/systemd/system/: units provided by installed packages
        # /etc/systemd/system/: units installed by the system administrator
        $service_file_location   = "/usr/lib/systemd/system/$product.service"
        $service_file_template   = 'stash/stash.service.erb'
        $service_lockfile        = "/var/lock/subsys/$product"
      } elsif $::operatingsystemmajrelease == '6' {
        $json_packages           = [ 'rubygem-json', 'ruby-json' ]
        $service_file_location   = "/etc/init.d/$product"
        $service_file_template   = 'stash/stash.initscript.redhat.erb'
        $service_lockfile        = "/var/lock/subsys/$product"
      } else {
        fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
      }
    } /Debian/: {
      $json_packages           = [ 'rubygem-json', 'ruby-json' ]
      $service_file_location   = "/etc/init.d/$product"
      $service_file_template   = 'stash/stash.initscript.debian.erb'
      $service_lockfile        = "/var/lock/$product"
    } default: {
      fail("${::operatingsystem} ${::operatingsystemmajrelease} not supported")
    }
  }
}
