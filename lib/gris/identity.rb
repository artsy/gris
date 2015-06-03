module Gris
  class Identity
    def self.health
      {
        name: name,
        base_url: base_url,
        hostname: hostname,
        revision: revision,
        pid: pid,
        parent_pid: parent_pid,
        platform: platform
      }
    end

    def self.name
      Gris.secrets.service_name
    end

    def self.base_url
      Gris.secrets.base_url
    end

    def self.hostname
      @hostname ||= `hostname`.strip
    end

    def self.revision
      @revision ||= `git rev-parse HEAD`.strip
    end

    def self.pid
      @pid ||= Process.pid
    end

    def self.parent_pid
      @ppid ||= Process.ppid
    end

    def self.platform
      {
        version: platform_revision,
        name: 'Gris'
      }
    end

    def self.platform_revision
      Gris::VERSION
    end
  end
end
