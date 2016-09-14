# -*- mode: ruby -*-
# vi: set ft=ruby :

hostname   = ENV['HOSTNAME'] ? ENV['HOSTNAME'] : 'bwcvagrant'
box        = ENV['BOX'] ? ENV['BOX'] : 'bento/ubuntu-14.04'
st2user    = ENV['ST2USER'] ? ENV['ST2USER']: 'st2admin'
st2passwd  = ENV['ST2PASSWORD'] ? ENV['ST2PASSWORD'] : 'Ch@ngeMe'
bwc_license  = ENV['BWC_LICENSE'] ? ENV['BWC_LICENSE'] : 'bwc_license'

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "st2" do |st2|
    # Box details
    st2.vm.box = "#{box}"
    st2.vm.hostname = "#{hostname}"

    # Box Specifications
    st2.vm.provider :virtualbox do |vb|
      vb.name = "#{hostname}"
      vb.memory = 1028
      vb.cpus = 2
    end

    # NFS-synced directory for pack development
    # Change "/path/to/directory/on/host" to point to existing directory on your laptop/host and uncomment:
    # config.vm.synced_folder "/path/to/directory/on/host", "/opt/stackstorm/packs", :nfs => true, :mount_options => ['nfsvers=3']

    # Configure a private network
    st2.vm.network :private_network, ip: "192.168.16.21"

    # Public (bridged) network may come handy for external access to VM (e.g. sensor development)
    # See https://www.vagrantup.com/docs/networking/public_network.html
    # st2.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'

    # Start shell provisioning.
    st2.vm.provision "shell" do |s|
      s.path = "scripts/install_bwc.sh"
      s.args   = "#{st2user} #{st2passwd} #{bwc_license}"
      s.privileged = false
    end
  end

end
