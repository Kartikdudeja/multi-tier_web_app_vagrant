# Vagrantfile for a Mutli-tier Java Web Application

servers=[
    {
        ### Database VM Configuration ###
        :hostname => "db01",
        :box => "geerlingguy/centos7",
        :ip => "192.168.20.11",
        :memory => "512",
        :cpu => "1",
        :vmname => "Vagrant_Web_App_db01",
        :script => "./scripts/mysql.sh"
    },
    {
        ### MemCache VM Configuration ###
        :hostname => "mc01",
        :box => "geerlingguy/centos7",
        :ip => "192.168.20.12",
        :memory => "512",
        :cpu => "1",
        :vmname => "Vagrant_Web_App_mc01",
        :script => "./scripts/memcache.sh"
    },
    {
        ### RabbitMQ VM Configuration ###
        :hostname => "rmq01",
        :box => "geerlingguy/centos7",
        :ip => "192.168.20.13",
        :memory => "512",
        :cpu => "1",
        :vmname => "Vagrant_Web_App_rmq01",
        :script => "./scripts/rabbitmq.sh"
    },
         {
        ### Tomcat Application Server VM Configuration ###
        :hostname => "app01",
        :box => "geerlingguy/centos7",
        :ip => "192.168.20.14",
        :memory => "1024",
        :cpu => "1",
        :vmname => "Vagrant_Web_App_app01",
        :script => "./scripts/tomcat.sh"
    },
    {
        ### Nginx VM Configuration ###
        :hostname => "web01",
        :box => "geerlingguy/centos7",
        :ip => "192.168.20.15",
        :memory => "512",
        :cpu => "1",
        :vmname => "Vagrant_Web_App_web01",
        :script => "./scripts/nginx.sh"
    }
]

Vagrant.configure("2") do |config|

    # manages the /etc/hosts file on guest machines in multi-machine environments
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true

    servers.each do |machine|
    
        config.vm.define machine[:hostname] do |node|

            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network :private_network, ip: machine[:ip]
    
            node.vm.provider :virtualbox do |vb|

                vb.customize ["modifyvm", :id, "--name", machine[:vmname]]
                vb.customize ["modifyvm", :id, "--memory", machine[:memory]]
                vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]

            end # end provider

            node.vm.provision "shell", path: machine[:script]

        end # end config
    end # end servers each loop
end