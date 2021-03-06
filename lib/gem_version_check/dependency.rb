require "rubygems"

module GemVersionCheck
  class Dependency

    attr_reader :name, :expected_version, :version

    def initialize(name, expected_version = nil)
      @name = name
      @expected_version = expected_version
    end

    def check(lock_file)
      @version = lock_file.version_for(@name)
      @used = !!@version
      return unless used?
      
      @result = expected_version == @version
    end

    def valid?
      !!@result
    end

    def used?
      @used
    end

    def gem_not_found?
      expected_version.nil?
    end

    def expected_version
      @expected_version ||= latest_version
    end

    def latest_version
      @latest_version ||= begin
        spec = retrieve_spec
        spec ? spec.version.to_s : nil
      end
    end

    private

    def retrieve_spec
      Gem.latest_spec_for(@name)
    end

  end
end